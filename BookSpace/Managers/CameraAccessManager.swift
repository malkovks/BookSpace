//
// File name: CameraAccessManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import AVFoundation
import VisionKit

enum CameraAccess: Error {
    case denied
    case restricted
    case notDetermined
    case unknown
    case noAccessToVisionKit
}

class CameraAccessManager {
    static let shared = CameraAccessManager()
    
    private init() {}
    
    
    
    func requestAccess(completion: @escaping (_ result: Result<Bool,CameraAccess>) -> Void) async {
        guard checkVisionKitAccess() else {
            completion(.failure(.noAccessToVisionKit))
            return
        }
        
        do {
            let status = try await checkCameraAccess()
            
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        granted ? completion(.success(true)) : completion(.failure(.denied))
                    }
                }
            case .restricted:
                completion(.failure(.restricted))
            case .denied:
                completion(.failure(.denied))
            case .authorized:
                completion(.success(true))
            @unknown default:
                completion(.failure(.unknown))
            }
            
        } catch {
            completion(.failure(.unknown))
        }
    }
    
    private func checkCameraAccess() async throws -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    private func checkVisionKitAccess() -> Bool {
        if #available(iOS 13.0, *) {
            return VNDocumentCameraViewController.isSupported
        }
        return false
    }
}

