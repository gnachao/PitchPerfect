//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by MacBKPro on 7/9/15.
//  Copyright (c) 2015 Gna Chao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
    }
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        RecordingInProgress.hidden = false
        recordButton.enabled = false
        //TODO: Record the user's voice
    }

    @IBAction func stopAudio(sender: UIButton) {
        RecordingInProgress.hidden = true
        //TODO: Stop recording the user's voice
    }
    
}

