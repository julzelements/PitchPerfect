//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Julian Scharf on 16/02/2016.
//  Copyright © 2016 Julian Scharf. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  var audioPlayer: AVAudioPlayer!
  var recievedAudio: RecordedAudio!
  var audioEngine: AVAudioEngine!
  var audioFile: AVAudioFile!
  var delayNode: AVAudioUnitDelay!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Sets the default device output to the loudspeaker (instead of the handset)
    try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
    
    //Initialize the audioPlayer and audioEngine from the recievedAudio
    audioPlayer = try! AVAudioPlayer(contentsOfURL: recievedAudio.filePathURL)
    audioEngine = AVAudioEngine()
    try! audioFile = AVAudioFile(forReading: recievedAudio.filePathURL)

    
  }
  
  //Note to reviewer: I put the constants in two structs so they are all in the one place.
  struct playingSpeeds {
    let fast: Float = 2.0
    let slow: Float = 0.5
  }
  struct playingPitch {
    let darthVader: Float = -500
    let chipmunk: Float = 1000
  }
  
  let speed = playingSpeeds()
  let pitch = playingPitch()
  
  func playAtSpeed(speed: Float) {
    audioPlayer.stop()
    audioEngine.stop()
    audioPlayer.enableRate = true
    audioPlayer.rate = speed
    audioPlayer.play()
  }
  
  func playAudioWithDelay() {
    let delayNode = AVAudioUnitDelay()
    delayNode.delayTime = 1
    audioEngine.attachNode(delayNode)
    playAudioWithEffectNode(delayNode)
  }
  
  func playAudioWithVariablePitch(pitch: Float){
    let changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch
    playAudioWithEffectNode(changePitchEffect)
  }
  
  @IBAction func playDarthVaderAudio(sender: UIButton) {
    playAudioWithVariablePitch(pitch.darthVader)
  }
  @IBAction func playChipMunkAudio(sender: UIButton) {
    playAudioWithVariablePitch(pitch.chipmunk)
  }
  @IBAction func playSlow(sender: UIButton) {
    playAtSpeed(speed.slow)
  }
  @IBAction func playFast(sender: UIButton) {
    playAtSpeed(speed.fast)
  }
  @IBAction func stopAudio(sender: UIButton) {
    audioPlayer.stop()
  }
  @IBAction func playDelay(sender: UIButton) {
    playAudioWithDelay()
  }
  
  func playAudioWithEffectNode(effectNode: AVAudioNode) {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
    
    let audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    audioEngine.attachNode(effectNode)
    audioEngine.connect(audioPlayerNode, to: effectNode, format: nil)
    audioEngine.connect(effectNode, to: audioEngine.outputNode, format: nil)
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    try! audioEngine.start()
    
    audioPlayerNode.play()
  }
  
}




