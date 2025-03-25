//
// File name: ScannerVie.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 24.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import VisionKit
import Vision

struct ScannerView: UIViewControllerRepresentable {
    
    var completion: (Result<String,Error>) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completion)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var completion: (Result<String,Error>) -> Void
        
        init(completion: @escaping (Result<String, Error>) -> Void) {
            self.completion = completion
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            TextRecognitionManager.shared.processScanResults(scan) { results in
                DispatchQueue.main.async {
                    self.completion(results)
                }
            }
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: any Error) {
            completion(.failure(error))
        }
        
        func recognizeText(from image: UIImage){
            let request = VNRecognizeTextRequest { request, error in
                guard let observation = request.results as? [VNRecognizedTextObservation], error == nil else {
                    self.completion(.failure(error ?? NSError(domain: "OCR", code: 0)))
                    return
                }
                let scannedText = observation.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                self.completion(.success(scannedText))
            }
            let handler = VNImageRequestHandler(cgImage: image.cgImage!,options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    self.completion(.failure(error))
                }
            }
            
        }
    }
}

