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
        // Not recording indicators
        stopButton.hidden = true
        recordButton.enabled = true
        recordButton.setTitle("Recording", forState: UIControlState.Normal)
        let image = UIImage(named: "Microphone.png") as UIImage!
        recordButton.setImage(image, forState: .Normal)
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        // Recording inicators
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

                println("You pressed Recording")
            case "Pausing":
                setRecordingStage(recordButton.currentTitle!)
                audioRecorder.pause()
                println("You pressed Pausing")
            case "Resuming":
                setRecordingStage(recordButton.currentTitle!)
                audioRecorder.record()
                println("You pressed Resuming")
        default:
            println("The recording button title is not in the implementation!")
            break
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            // Step 1 - Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // Step 2 - Move to the next scene aka peform segue
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
                recordButton.setTitle("Pausing", forState: UIControlState.Normal)
                stopButton.hidden = false
                RecordingInProgress.hidden = false
                let image = UIImage(named: "Pause.png") as UIImage!
                recordButton.setImage(image, forState: .Normal)
            case "Pausing":
                recordButton.setTitle("Resuming", forState: UIControlState.Normal)
                let image = UIImage(named: "Resume.png") as UIImage!
                recordButton.setImage(image, forState: .Normal)
                RecordingInProgress.hidden = true
            case "Resuming":
                recordButton.setTitle("Pausing", forState: UIControlState.Normal)
                let image = UIImage(named: "Pause.png") as UIImage!
                recordButton.setImage(image, forState: .Normal)
                RecordingInProgress.hidden = false
        default:
            recordButton.setTitle("Recording", forState: UIControlState.Normal)
            stopButton.hidden = true
            RecordingInProgress.hidden = true
            let image = UIImage(named: "Microphone.png") as UIImage!
            recordButton.setImage(image, forState: .Normal)
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        RecordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
        //TODO: Stop recording the user's voice
    }
    
}

