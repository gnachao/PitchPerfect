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
    
    @IBOutlet weak var audioSwitch: UISwitch!
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    var filePathUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filePathUrl = receivedAudio.filePathUrl
        passAudioFileToPlayer(filePathUrl)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
    }

    func passAudioFileToPlayer(filePathUrl: NSURL!){
        audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: filePathUrl, error: nil)
    }
    
    func stopPlaying(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    func playAudioWithVariableRate(rate: Float){
        stopPlaying()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0 //play from the start
        audioPlayer.play()
    }

    func playAudioWithEffect(effect: String, value: Float) {
        stopPlaying()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        switch effect{
            case "pitch":
                if (value >= -2400 && value <= 2400) {
                    var pitchNode = AVAudioUnitTimePitch()
                    pitchNode.pitch = value
                    audioEngine.attachNode(pitchNode)
                    
                    // connect player --> audio effect
                    audioEngine.connect(audioPlayerNode, to: pitchNode, format: nil)
                    // connect audio effect --> output
                    audioEngine.connect(pitchNode, to: audioEngine.outputNode, format: nil)
                }
            case "echo":
                var echoNode = AVAudioUnitDelay()
                echoNode.delayTime = NSTimeInterval(value)
                audioEngine.attachNode(echoNode)
            
                audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
                audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
            case "reverb":
                if (value >= 0 && value <= 100) {
                    var reverbNode = AVAudioUnitReverb()
                    reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
                    reverbNode.wetDryMix = value
                    audioEngine.attachNode(reverbNode)
                
                    audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
                    audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
                }
        default:
            println("effect is not in implemented!")
        }

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }

    @IBAction func playSlowAudio(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithEffect("echo", value: 0.3)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithEffect("reverb", value: 60)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithEffect("pitch", value: 1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithEffect("pitch", value: -1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopPlaying()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func switchAudio(sender: UISwitch) {
        if sender.on{
            if var filePath = NSBundle.mainBundle().pathForResource("sample", ofType: "wav"){
                filePathUrl = NSURL.fileURLWithPath(filePath)
            }else{
                filePathUrl = receivedAudio.filePathUrl
                println("the filepath is empty")
            }
        }else{
            filePathUrl = receivedAudio.filePathUrl
        }
        passAudioFileToPlayer(filePathUrl)
    }
}
