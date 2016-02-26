import Foundation
import UIKit

class testClass {
  
  
  enum displayState: Int {
  case notRecording = 0
  case recording = 1
  case paused = 2
  func updateDisplay() {
    switch self {
    case .notRecording:
      print("do methods that setup notRecording")
    case .recording:
      print("do methods that setup recording")
    case .paused:
      print("do methods that setup paused")
    }
  }
}

var display: displayState!


  
}


