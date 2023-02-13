//
//  Speaker.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 01.12.22.
//

import Foundation
import AVFoundation

class Speaker: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    var utterance: AVSpeechUtterance?
    
    @Published var isSpeaking: Bool = false
    
    override init(){
        super.init()
        self.synthesizer.delegate = self
    }
    
    func initializeSpeaker(content: String, voice: PostReadingVoice) {
        utterance = AVSpeechUtterance(string: content)
        utterance?.voice = AVSpeechSynthesisVoice(identifier: voice == .male ?
                                                  "com.apple.ttsbundle.Daniel-compact" :
                                                    "com.apple.ttsbundle.Samantha-compact")
        utterance?.rate = 0.5
    }
    
    func speak() {
        if let utterance {
            synthesizer.speak(utterance)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isSpeaking = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }
    
}
