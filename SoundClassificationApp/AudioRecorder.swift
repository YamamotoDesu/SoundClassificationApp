//
//  AudioRecorder.swift
//  SoundClassificationApp
//
//  Created by Mohammad Azam on 3/18/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    lazy var recordingSession: AVAudioSession = {
        return AVAudioSession.sharedInstance()
    }()
    
    var audioRecorder: AVAudioRecorder!
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.stopRecording()
    }
    
    func stopRecording() {
        if self.audioRecorder != nil {
            self.audioRecorder.stop()
            self.audioRecorder = nil
        }
    }
    
    func startRecording(fileURL: URL) {
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        do {
            try self.recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { (allowed) in
                completion(allowed)
            }
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
}
