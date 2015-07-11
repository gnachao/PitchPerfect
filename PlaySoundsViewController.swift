//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by MacBKPro on 7/9/15.
//  Copyright (c) 2015 Gna Chao. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioEchoPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    var filePathUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var filePath = NSBundle.mainBundle().pathForResource("sample", ofType: "wav"){
            filePathUrl = NSURL.fileURLWithPath(filePath)
        }else{
            filePathUrl = receivedAudio.filePathUrl
            println("the filepath is empty")
        }
        
//        filePathUrl = receivedAudio.filePathUrl
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
        audioEchoPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: filePathUrl, error: nil)
    }


    
    func stopNowPlaying(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariableRate(rate: Float){
        stopNowPlaying()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0 //play from the start
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopNowPlaying()
        
        var audioPlayNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayNode.play()
    }
    
    func playAudioWithVariableReverb(wetDry: Float) {
        stopNowPlaying()
        
        var audioPlayNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayNode)

        
        let unitReverb = AVAudioUnitReverb()
        unitReverb.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
        unitReverb.wetDryMix = wetDry
        audioEngine.attachNode(unitReverb)
        
        audioEngine.connect(audioPlayNode, to: unitReverb, format: nil)
        audioEngine.connect(unitReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayNode.play()
    }
    
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithVariableRate(1.0)
        
        let delay:NSTimeInterval = 0.1//100ms
        var playtime:NSTimeInterval
        
        playtime = audioEchoPlayer.deviceCurrentTime + delay
        audioEchoPlayer.stop()
        audioEchoPlayer.currentTime = 0
        audioEchoPlayer.volume = 0.8;
        audioEchoPlayer.playAtTime(playtime)
    }
    
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithVariableReverb(60)
    }

    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopNowPlaying()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
