//
// File name: BookDetailViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

class BookDetailViewModel: ObservableObject {
    @Published var backgroundColor: Color = .white
    
    func extractColor(from image: Image){
        let uiImage = image.asUIImage()
        DispatchQueue.global(qos: .userInitiated).async {
            if let dominantColor = self.getDominantColor(from: uiImage){
                DispatchQueue.main.async {
                    self.backgroundColor = Color(dominantColor)
                }
            }
        }
    }
    
    private func getDominantColor(from image: UIImage) -> UIColor? {
        guard let cgImage = image.cgImage else { return nil }
        let width = 10, height = 10
        let bitmapData = calloc(width * height * 4, MemoryLayout<UInt8>.size)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let ctx = context else { return nil }
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        guard let data = bitmapData else { return nil }
        var redTotal = 0, greenTotal = 0, blueTotal = 0
        for x in 0..<width {
            for y in 0..<height {
                let pixelIndex = (y * width + x) * 4
                redTotal += Int(data.load(fromByteOffset: pixelIndex, as: UInt8.self))
                greenTotal += Int(data.load(fromByteOffset: pixelIndex + 1, as: UInt8.self))
                blueTotal += Int(data.load(fromByteOffset: pixelIndex + 2, as: UInt8.self))
            }
        }
        let pixelCount = width * height
        let avgRed = redTotal / pixelCount
        let avgGreen = greenTotal / pixelCount
        let avgBlue = blueTotal / pixelCount
        
        return UIColor(red: CGFloat(avgRed), green: CGFloat(avgGreen), blue: CGFloat(avgBlue), alpha: 1)
    }
}
