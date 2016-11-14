//
//  ViewController.swift
//  MusicAssistant
//
//  Created by Wu Jian on 04/11/2016.
//  Copyright © 2016 Baresi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cbCppToSwift: (double_t) -> Void = swiftCallbackFunc;
        RegisterCallBack(cbCppToSwift)
    }
    
    func swiftCallbackFunc (frequency : double_t)
    {
        print("frequency detected: ", frequency)
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
            // sender.title = "Stop"
            isRecording = true
        }
        else
        {
            print("stop recording...")
            AQRecorderObjC.stopRecord()
            // sender.title = "Start"
            isRecording = false
        }
    }

}

