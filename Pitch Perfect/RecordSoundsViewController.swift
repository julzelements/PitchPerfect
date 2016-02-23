//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Julian Scharf on 16/02/2016.
//  Copyright © 2016 Julian Scharf. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
  
  var audioRecorder:AVAudioRecorder!
  var recordedAudio:RecordedAudio!
  var userIsInTheMiddleOfRecording: Bool = false

  
  override func viewWillAppear(animated: Bool) {
    recordingInProgress.hidden = false
    recordingInProgress.text = "Tap to Record"
    stopButton.hidden = true
    pauseButton.hidden = true
  }

  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var recordingInProgress: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  
  @IBAction func recordAudio(sender: UIButton) {
    
    if userIsInTheMiddleOfRecording == false {
      let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
      let recordingName = "my_audio.wav"
      let pathArray = [dirPath, recordingName]
      let filePath = NSURL.fileURLWithPathComponents(pathArray)
      print(filePath)
      
      let session = AVAudioSession.sharedInstance()
      try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
      
      try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
      audioRecorder.delegate = self
      audioRecorder.meteringEnabled = true
      audioRecorder.prepareToRecord()
      audioRecorder.record()
      
      userIsInTheMiddleOfRecording = true
      recordingInProgress.text = "Recording in Progress..."
      pauseButton.hidden = false
      stopButton.hidden = false
      
    } else if userIsInTheMiddleOfRecording == true {
      audioRecorder.record()
      recordingInProgress.text = "Recording in Progress..."
      pauseButton.hidden = false
      stopButton.hidden = false
    }
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    if(flag) {
      recordedAudio = RecordedAudio(audioFilePathURL: recorder.url, audioTitle: recorder.url.lastPathComponent!)
      self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      print("Recording was not successful")
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording") {
      let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      let data = sender as! RecordedAudio
      playSoundsVC.recievedAudio = data
    }
  }
  
  @IBAction func pauseRecording(sender: UIButton) {
    if userIsInTheMiddleOfRecording == true {
      audioRecorder.pause()
      recordingInProgress.text = "Tap to Resume Recording"
      pauseButton.hidden = true
    }
  }
  
  @IBAction func stopRecording(sender: UIButton) {
    recordingInProgress.hidden = true
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
}