//
//  ViewController.swift
//  MusicAssistant
//
//  Created by Wu Jian on 04/11/2016.
//  Copyright © 2016 Baresi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var lblPitch: UILabel!
    @IBOutlet weak var tblMusic: UITableView!
    
    var _musicDetector = MusicDetector()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cbCppToSwift: (double_t) -> Void = swiftCallbackFunc;
        RegisterCallBack(cbCppToSwift)
        _musicDetector._musicNoteListener = noteListener
    }
    
    func noteListener (pitch : swift_pitch_t)
    {
        let displayText = PitchDictionary.indexToPitchName(idx: pitch._pitchIndex)
            + ";" + String(format: "%.2f", pitch.maxNegDeviationPercentage()) + "%"
            + "; " + String(format: "%.2f", pitch.maxPosDeviationPercentage()) + "%"
            + ";" + String(format: "%.2f", pitch._maxNegativeDeviation)
            + ";" + String(format: "%.2f", pitch._maxPositiveDeviation)

        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
            {
                DispatchQueue.main.async
                {
                    self.lblPitch.text = String(displayText)
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
        var title : String? = nil
        
        if (!isRecording)
        {
            print("start recording...")
            AQRecorderObjC.initRecorder()
            AQRecorderObjC.startRecord()
            title = "Stop"
        
            isRecording = true
        }
        else
        {
            print("stop recording...")
            AQRecorderObjC.stopRecord()
            title = "Start"
            isRecording = false
        }

        //sender.setTitle(title, for: .normal)
    }

    private func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath)->UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        cell.textLabel!.text = "/(data.object(at: indexPath.row))"
        return cell
    }
    
}

