//
//  Pitch.swift
//  MusicAssistant
//
//  Created by Wu Jian on 19/11/2016.
//  Copyright © 2016 Baresi. All rights reserved.
//

import Foundation

typealias pitch_idx_t = Int
typealias pitch_freq_t = Double
typealias pitch_duration_t = Double
typealias pitch_name_t = String

struct swift_pitch_t
{
    var _pitchIndex : pitch_idx_t
    var _frequency : pitch_freq_t
    var _totalPitchCounter : Int
    var _maxPositiveDeviation : pitch_freq_t
    var _maxNegativeDeviation : pitch_freq_t
    var _avgPositiveDeviation : pitch_freq_t
    var _avgNegativeDeviation : pitch_freq_t
    var _duration : pitch_duration_t
    
    func maxPosDeviationPercentage() -> Double
    {
        return _maxPositiveDeviation * 100.00 / PitchDictionary.indexToFrequency(idx: _pitchIndex);
    }
    func maxNegDeviationPercentage() -> Double
    {
        return _maxNegativeDeviation * 100.00 / PitchDictionary.indexToFrequency(idx: _pitchIndex);
    }
    
    func avgPosDeviationPercentage() -> Double
    {
        return _avgPositiveDeviation * 100.00 / PitchDictionary.indexToFrequency(idx: _pitchIndex);
    }
    func avgNegDeviationPercentage() -> Double
    {
        return _avgNegativeDeviation * 100.00 / PitchDictionary.indexToFrequency(idx: _pitchIndex);
    }

}
