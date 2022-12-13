//
//  AudioRecorderViewModel.swift
//  DatingChamber
//
//  Created by Karen Mirakyan on 13.12.22.
//

import Foundation
import AVKit
import AVFoundation
import Combine

class AudioRecorderViewModel: ObservableObject {
    // 1
    private var audioRecorder: AVAudioRecorder?
    private var audioSession: AVAudioSession
    private var timer: Timer?
    
    let url: URL
    
    // 2
    @Published var recording: Bool = false
    
    @Published var showRecording: Bool = false
    @Published var showPreview: Bool = false
    @Published var audioDuration: Double = 0
    @Published var permissionStatus: AVAudioSession.RecordPermission
    
    init() {
        
        // 3 request permission
        self.audioSession = AVAudioSession.sharedInstance()
        self.permissionStatus = self.audioSession.recordPermission
        
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(NSUUID().uuidString).m4a"
        self.url = directory.appendingPathComponent(fileName)
        
        requestPermission()

        let recorderSettings = [
            
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 12000,
            AVNumberOfChannelsKey : 1,
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
        ]

        // 5
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
        } catch {
            print(error)
        }
    }
    
    func recordAudio() {
        startMonitoring()
    }
    
    // 6
    private func startMonitoring() {
        if let audioRecorder = audioRecorder {
            
            audioDuration = 0
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            
            recording = audioRecorder.isRecording
            showRecording = audioRecorder.isRecording
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                self.audioDuration += 0.1
                if self.audioDuration >= 60 {
                    self.stopRecord()
                    
                    self.recording = false
                    self.showRecording = false
                    self.showPreview = true
                }
                audioRecorder.updateMeters()
            })
        }
    }
    
    func requestPermission() {
        if audioSession.recordPermission == .undetermined {
            audioSession.requestRecordPermission { (isGranted) in
                if isGranted {
                    self.permissionStatus = .granted
                }
                if !isGranted {
                    print("no access to record")
                }
            }
        }
    }
    
    func stopRecord() {
        if audioDuration > 2 {
            audioRecorder?.stop()
            timer?.invalidate()
            
        }
    }
    
    // 8
    deinit {
        timer?.invalidate()
        audioRecorder?.stop()
    }
}
