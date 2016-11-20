//
//  MusicDetector.swift
//  MusicAssistant
//
//  Created by Wu Jian on 18/11/2016.
//  Copyright © 2016 Baresi. All rights reserved.
//

import Foundation

class PitchWindow
{
    static private let MAX_WINDOW_SIZE = 50
    static private let PITCH_COUNT = 108
    var _windowSize : Int  = 0          // size of the window
    private var _ring : [Int] = Array(repeating: 0, count: MAX_WINDOW_SIZE)     // circular ring of pitch window. size = MAX_WINDOW_SIZE
    private var _pos : Int = 0          // position of next incoming pitch in the window
    private var _pitchWindowMap : [Int] = Array(repeating: 0, count: PITCH_COUNT)    // counter map of the pitch window. size = PITCH_COUNT
    
    func insert (idx : Int) -> Int
    {
        _ring[_pos] = idx
        _pos += 1
        _pos %= _windowSize;
        return detected();
    }
    
    /* get the pitch detected */
    func detected() -> Int
    {
        var result : Int = -1;
        var maxCount : Int = 0;
        var currentCount : Int = 0;
        
        for i in 0..._windowSize
        {
            _pitchWindowMap[_ring[i]] = 0;
        }
        
        for i in 0..._windowSize
        {
            if (_ring[i] != -1) {
                _pitchWindowMap[_ring[i]] += 1
                currentCount = _pitchWindowMap[_ring[i]];
            }
            if (currentCount > maxCount) {
                maxCount = currentCount;
                result = _ring[i];
            }
        }
        
        return result;
    }
    
    
}

class MusicDetector
{
    var _detectedPitchCounter : Int = 0
    var _lastDetectedIdx : Int = -1
    var _pitchWindow : PitchWindow = PitchWindow()
    
    var _maxPositiveDeviation : pitch_freq_t = 0
    var _maxNegativeDeviation : pitch_freq_t = 0
    var _acuPositiveDeviation : pitch_freq_t = 0
    var _acuNegativeDeviation : pitch_freq_t = 0
    var _totalPitchCounter : Int = 0
    var _musicNoteListener : ((swift_pitch_t)->Void)? = nil
    static let PITCH_COUNT = 108
    
    init ()
    {
        _pitchWindow._windowSize = 10
        return
    }
    
    func startDetection(windowSize : Int)
    {
        _detectedPitchCounter = 0
        _pitchWindow._windowSize = windowSize
    }
    
    func insert(pitchSample : pitch_freq_t)
    {
        var detectedIdx : Int = -1;
        var insertIdx : Int = -1;
        var deviation : Double = -1;
        
        insertIdx = detectAPitch (pitchSample: pitchSample, deviation: &deviation);
        if (insertIdx<0 || insertIdx>=MusicDetector.PITCH_COUNT)
        {
            // invalid sample
            print ("Invalid Sample!")
            return
        }
        
        detectedIdx = _pitchWindow.insert(idx: insertIdx);
        
        if (detectedIdx != _lastDetectedIdx)
        {
            let detectedPitch = swift_pitch_t(
                _pitchIndex: detectedIdx,
                _frequency: PitchDictionary.indexToFrequency(idx: detectedIdx),
                _totalPitchCounter: _totalPitchCounter,
                _maxPositiveDeviation: _maxPositiveDeviation,
                _maxNegativeDeviation: _maxNegativeDeviation,
                _avgPositiveDeviation: _totalPitchCounter==0 ? Double(-0xfff):(_acuNegativeDeviation/Double(_totalPitchCounter)),
                _avgNegativeDeviation: _totalPitchCounter==0 ? Double(0xfff):_acuPositiveDeviation/Double(_totalPitchCounter),
                _duration: 0)
            _musicNoteListener!(detectedPitch)
            
            _lastDetectedIdx = detectedIdx;
            _detectedPitchCounter = 0;
            _maxPositiveDeviation = 0;
            _maxNegativeDeviation = 0;
            _acuPositiveDeviation = 0;
            _acuNegativeDeviation = 0;
            _totalPitchCounter = 0;
        }
        else
        {
            _detectedPitchCounter += 1;
            
            // calculate deviation
            if (insertIdx == detectedIdx)
            {
                if (deviation > 0)
                {
                    _maxPositiveDeviation = deviation>_maxPositiveDeviation ? deviation:_maxPositiveDeviation;
                    _acuPositiveDeviation += deviation;
                }
                else
                {
                    _maxNegativeDeviation = deviation<_maxNegativeDeviation ? deviation:_maxNegativeDeviation;
                    _acuNegativeDeviation += deviation;
                }
                _totalPitchCounter += 1;
            }
        }

        return;
    }
    
    func stopDetection()
    {
        
    }
    
    func detectAPitch(pitchSample : pitch_freq_t, deviation : inout pitch_freq_t) -> Int
    {
        var idx : Int = -1;
        
        idx = PitchDictionary.frequencyToIndex(frequency: pitchSample, deviation: &deviation);
        
        return idx;
    }
    
}
