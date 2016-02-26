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
  var recordingIsPaused: Bool = false
  
  enum DisplayState {
    case notRecording
    case recording
    case paused
  }
  
  func updateDisplay(displayState: DisplayState) {
    switch displayState {
    case .notRecording:
      recordingInProgress.hidden = false
      recordingInProgress.text = "Tap to Record"
      stopButton.hidden = true
      pauseButton.hidden = true
    case .recording:
      recordingInProgress.text = "Recording in Progress..."
      pauseButton.hidden = false
      stopButton.hidden = false
    case .paused:
      recordingInProgress.text = "Paused \n Tap to Resume Recording"
      pauseButton.hidden = true
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    updateDisplay(.notRecording)
  }
  
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var recordingInProgress: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  
  @IBAction func recordAudio(sender: UIButton) {
    if recordingIsPaused == false {
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let recordingName = "my_audio.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
    try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
    
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    updateDisplay(.recording)
    } else {
      audioRecorder.record()
      recordingIsPaused = false
      updateDisplay(.recording)
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
    audioRecorder.pause()
    updateDisplay(.paused)
    recordingIsPaused = true
  }
  
  @IBAction func stopRecording(sender: UIButton) {
    recordingInProgress.hidden = true
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
}
