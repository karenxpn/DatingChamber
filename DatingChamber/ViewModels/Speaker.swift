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
    
    func initializeSpeaker(content: String) {
        utterance = AVSpeechUtterance(string: content)
        utterance?.voice = AVSpeechSynthesisVoice(language: "en-US")
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
