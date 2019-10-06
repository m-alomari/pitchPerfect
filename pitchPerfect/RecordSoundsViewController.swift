//
//  RecordSoundsViewController.swift
//  pitchPerfect
//
//  Created by Mohammed Alomari on 2019-09-12.
//  Copyright © 2019 Mohammed Alomari. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // AV instant
    var audioRecorder: AVAudioRecorder!
    
    // Outlets
    @IBOutlet weak var startRecording: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var tapToStartRecording: UILabel!
    
    // App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CheckPoint #0 - loadApp - Application has been loaded!")
    }

    override func viewWillAppear(_ animated: Bool) {
        print("CheckPoint #1 - startApp - Application has started")
        configurationsBeforeUsage()
    }
    
    // Configuration
    func configurationsBeforeUsage(){
        stopRecording.isEnabled = false
        print("Welcome #user#")
    }
    
    // Actions
    @IBAction func startRecording(_ sender: Any) {
        print("CheckPoint #2 - Action - Started to record")
        buttonToggler()
        recordingStatusToggler()
        prepareForRecording()
        doRecord()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("Checkpoint #3 - Action - Stopped the recordinng")
        buttonToggler()
        recordingStatusToggler()
        doStopRecording()

    }
    
    // helpers
    func buttonToggler(){
        startRecording.isEnabled = startRecording.isEnabled == true ? false : true
        stopRecording.isEnabled = stopRecording.isEnabled == true ? false : true
    }
    
    func recordingStatusToggler(){
        tapToStartRecording.text = tapToStartRecording.text == "Tap to start recording" ? "Recoding in progress..." : "Tap to start recording"
    }
    
    func prepareForRecording(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        print(filePath!)
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        print("CheckPoint #4 - preparing - Recording is ready")
    }
    func doRecord(){
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        print("CheckPoint #5 - recording - Recording is on")

    }
    
    func doStopRecording(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        print("CheckPoint #6 - recording - Recording is off")

    }
    
    // Delegates
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("CheckPoint #7 - delegate - Recording failed")
        }
    }
    // segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            print("CheckPoint #8 - URL \(recordedAudioURL)")
        }
    }
    
    
}

