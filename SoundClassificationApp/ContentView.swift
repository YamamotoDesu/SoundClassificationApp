//
//  ContentView.swift
//  SoundClassificationApp
//
//  Created by Mohammad Azam on 3/18/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI
import AVFoundation
import SoundAnalysis
import CoreML

struct ContentView: View {
    
    private var audioRecorder = AudioRecorder()
    @State private var recording: Bool = false
    @State private var allowed: Bool = false
    @State private var classification: String = ""
    
    let emojis = ["cow":"🐮","dog":"🐶"]

    private var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return (paths.first!)
    }
    
    private var audioFilePath: URL {
        print(documentsDirectory.appendingPathComponent("recordedAudio.m4a"))
        return documentsDirectory.appendingPathComponent("recordedAudio.m4a")
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text(self.emojis[self.classification] ?? "")
                .font(.custom("Arial", size: 100))
            
            Spacer()
            
            Button(recording ? "Stop Recording" : "Start Recording") {
                
                self.recording = !self.recording
                if self.recording {
                    self.audioRecorder.startRecording(fileURL: self.audioFilePath)
                    
                } else {
                    self.audioRecorder.stopRecording()
                }
                
            }
           
            .padding()
               .foregroundColor(Color.white)
                .background(recording ? Color.red : Color.green)
                .cornerRadius(10)
            
            Spacer()
            
            
            Button("Classify") {
                
               
                 
                
            }.padding()
                .foregroundColor(Color.white)
                .background(Color.gray)
                .cornerRadius(10)
        }
        
        .onAppear {
            self.audioRecorder.requestPermission { (allowed) in
                DispatchQueue.main.async {
                    print(allowed)
                    self.allowed = allowed
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
