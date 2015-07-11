//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gna Chao on 7/9/15.
//  Copyright (c) 2015 Gna Chao. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        let image = UIImage(named: "Microphone.png") as UIImage!
        recordButton.setTitle("Recording", forState: .Normal)
        recordButton.setImage(image, forState: .Normal)
        
        stopButton.hidden = true
        RecordingInProgress.text = "Tap to Record"
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        switch recordButton.currentTitle! {
            case "Recording":
                setRecordingStage(recordButton.currentTitle!)
                
                // Define recorded file path, recorded file name can be unique by using YYYYMMDDHHSS but not require for this project.
                let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
                var pathArray = [dirPath, "recorded.wav"]
                let filePath = NSURL.fileURLWithPathComponents(pathArray)
                
                // Setup audio session to Record Session only
                var session = AVAudioSession.sharedInstance()
                session.setCategory(AVAudioSessionCategoryRecord, error: nil)
                
                // Initialize and prepare the recorder
                audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
                audioRecorder.delegate = self // to use audio functions in this class
                audioRecorder.meteringEnabled = true;
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            case "Pausing":
                setRecordingStage(recordButton.currentTitle!)
                audioRecorder.pause()
            case "Resuming":
                setRecordingStage(recordButton.currentTitle!)
                audioRecorder.record()
        default:
            println("The recording button title is not in the implementation!")
            break
        }
    }

    // perform asap recording is finished
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            // Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // Move to the next scene aka peform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    // pass the recorded audio
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // Set characteristics of each recording stage.
    func setRecordingStage(stage: String){
        switch stage {
            case "Recording":
                let image = UIImage(named: "Pause.png") as UIImage!
                recordButton.setTitle("Pausing", forState: UIControlState.Normal)
                recordButton.setImage(image, forState: .Normal)
                
                stopButton.hidden = false
                RecordingInProgress.text = "Recording ..."
            case "Pausing":
                let image = UIImage(named: "Resume.png") as UIImage!
                recordButton.setTitle("Resuming", forState: .Normal)
                recordButton.setImage(image, forState: .Normal)
                
                RecordingInProgress.text = "Tap to Resume Recording"
            case "Resuming":
                let image = UIImage(named: "Pause.png") as UIImage!
                recordButton.setTitle("Pausing", forState: .Normal)
                recordButton.setImage(image, forState: .Normal)
                
                RecordingInProgress.text = "Recording ..."
        default:
            let image = UIImage(named: "Microphone.png") as UIImage!
            recordButton.setTitle("Recording", forState: .Normal)
            recordButton.setImage(image, forState: .Normal)
            
            stopButton.hidden = true
            RecordingInProgress.text = "Tap to Record"
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
    }
    
}

