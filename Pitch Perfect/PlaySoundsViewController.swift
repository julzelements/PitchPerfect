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
  
  //Note to reviewer: I put the constants in one struct so they are all in the one place.
  struct audioStruct {
    let fast: Float = 2.0
    let slow: Float = 0.5
    let darthVader: Float = -1000
    let chipmunk: Float = 1000
    let delay: Double = 1
  }
  
  let audioConstant = audioStruct()
  
  func stopAll() {
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
  }
  
  func playAtSpeed(speed: Float) {
    stopAll()
    audioPlayer.enableRate = true
    audioPlayer.rate = speed
    audioPlayer.play()
  }
  
  func playAudioWithDelay(delay: Double) {
    let delayNode = AVAudioUnitDelay()
    delayNode.delayTime = delay
    playAudioWithEffectNode(delayNode)
  }
  
  func playAudioWithVariablePitch(pitch: Float){
    let changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch
    playAudioWithEffectNode(changePitchEffect)
  }
  
  //This is a modular function that can be used to play various audioNodes
  func playAudioWithEffectNode(effectNode: AVAudioNode) {
    stopAll()
    let audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    audioEngine.attachNode(effectNode)
    audioEngine.connect(audioPlayerNode, to: effectNode, format: nil)
    audioEngine.connect(effectNode, to: audioEngine.outputNode, format: nil)
    
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    try! audioEngine.start()
    
    audioPlayerNode.play()
  }
  
  @IBAction func playDarthVaderAudio(sender: UIButton) {
    playAudioWithVariablePitch(audioConstant.darthVader)
  }
  @IBAction func playChipMunkAudio(sender: UIButton) {
    playAudioWithVariablePitch(audioConstant.chipmunk)
  }
  @IBAction func playSlow(sender: UIButton) {
    playAtSpeed(audioConstant.slow)
  }
  @IBAction func playFast(sender: UIButton) {
    playAtSpeed(audioConstant.fast)
  }
  @IBAction func stopAudio(sender: UIButton) {
    stopAll()
  }
  @IBAction func playDelay(sender: UIButton) {
    playAudioWithDelay(audioConstant.delay)
  }
  
}




