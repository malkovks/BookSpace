//
// File name: TextRecognitionManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import Vision
import VisionKit

class TextRecognitionManager {
    static let shared = TextRecognitionManager()
    private init() {}
    
    private func recognizeText(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: nil)))
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.success(""))
                return
            }
            
            let recognizedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            completion(.success(recognizedText))
        }
        
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }
    
    @available(iOS 13.0, *)
    func processScanResults(_ results: VNDocumentCameraScan, completion: @escaping (Result<String, Error>) -> Void) {
        var allText = ""
        let dispatchGroup = DispatchGroup()
        
        for pageIndex in 0..<results.pageCount {
            dispatchGroup.enter()
            
            let image = results.imageOfPage(at: pageIndex)
            recognizeText(from: image) { result in
                switch result {
                case .success(let text):
                    allText += text + "\n\n"
                case .failure(let error):
                    print("Error on page \(pageIndex): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(allText))
        }
    }
}
