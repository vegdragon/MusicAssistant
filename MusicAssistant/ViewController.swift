//
//  ViewController.swift
//  MusicAssistant
//
//  Created by Wu Jian on 04/11/2016.
//  Copyright © 2016 Baresi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblPitch: UILabel!
    var _musicDetector = MusicDetector()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cbCppToSwift: (double_t) -> Void = swiftCallbackFunc;
        RegisterCallBack(cbCppToSwift)
        _musicDetector._musicNoteListener = noteListener
    }
    
    func noteListener (pitch : swift_pitch_t)
    {
        let pitchName = PitchDictionary.indexToPitchName(idx: pitch._pitchIndex)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
            {
                DispatchQueue.main.async
                {
                    self.lblPitch.text = String(pitchName)
                }
            }
    }
    
    func swiftCallbackFunc (frequency : double_t)
    {
        print("frequency detected: ", frequency)
        _musicDetector.insert(pitchSample: frequency)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var isRecording = false;
    @IBAction func startRecording(_ sender: AnyObject)
    {
        if (!isRecording)
        {
            print("start recording...")
            AQRecorderObjC.initRecorder()
            AQRecorderObjC.startRecord()
            //sender.setTitle("Stop", for: UIControlState.normal)
        
            isRecording = true
        }
        else
        {
            print("stop recording...")
            AQRecorderObjC.stopRecord()
            //sender.setTitle("Start", for: UIControlState.normal)
            isRecording = false
        }
    }

}

