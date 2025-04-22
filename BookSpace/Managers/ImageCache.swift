//
// File name: Untitled.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private var memoryUsage: Int = 0
    
    private init() {
        cache.totalCostLimit = 1024 * 1024 * 100
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String){
        let imageDataSize = image.diskSizeInBytes
        cache.setObject(image, forKey: key as NSString)
        memoryUsage += imageDataSize
    }
    
    func removeAll(){
        cache.removeAllObjects()
        memoryUsage = 0
    }
    
    func totalMemoryUsage() -> Int {
        return memoryUsage
    }
    
    func totalMemoryUsageInMB() -> Double {
        return Double(memoryUsage) / (1024 * 1024)
    }
}

