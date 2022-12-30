//
//  AudioClassfier.swift
//  SoundClassificationApp
//
//  Created by 山本響 on 2022/12/30.
//  Copyright © 2022 Mohammad Azam. All rights reserved.
//

import Foundation
import AVFoundation
import SoundAnalysis

class AudioClassifier: NSObject, SNResultsObserving {
    
    private let model: MLModel
    private let request: SNClassifySoundRequest
    private var results: [(String, Double)] = []
    private var completion: (String?) -> () = { _ in }
    
    init?(model: MLModel) {
        
        guard let request = try? SNClassifySoundRequest(mlModel: model) else {
            return nil
        }
        
        self.model = model
        self.request = request
        
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        guard let results = result as? SNClassificationResult,
                  let result = results.classifications.first else { return }
        
        if result.confidence > 0.0 {
            self.results.append((result.identifier, result.confidence))
        }
        
    }
    
    func requestDidComplete(_ request: SNRequest) {
        
        self.results.sort {
            return $0.1 > $1.1
        }

        guard let result = self.results.first else { return }
        
        self.completion(result.0)
        
    }
    
    func classify(audioFiles: URL, completion: @escaping (String?) -> Void) {
        
        self.completion = completion
        
        guard let analyzer = try? SNAudioFileAnalyzer(url: audioFiles),
              let _ = try? analyzer.add(self.request, withObserver: self) else {
            return
        }
        
        analyzer.analyze()
    }
}
