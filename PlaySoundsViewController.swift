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
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if var filePath = NSBundle.mainBundle().pathForResource("18 天长地久", ofType: "mp3"){
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
//            audioPlayer.enableRate = true
//        }else{
//            println("the filepath is empty")
//        }
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithVariableRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0 //play from the start
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithVariableRate(1.0)
    }
    

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    //TODO: playSlowAudio and playFastAudio use one function to call them

}
