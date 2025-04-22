//
// File name: UIImage+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import UIKit

extension UIImage {
    func getDominantColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = 10
        let height = 10
        let bitmapData = calloc(width * height * 4, MemoryLayout<UInt8>.size)
        defer { free(bitmapData) }
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        guard let context = CGContext(data: bitmapData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let data = bitmapData else { return nil }
        var redTotal = 0, greenTotal = 0, blueTotal = 0
        for x in 0..<width {
            for y in 0..<height {
                let offset = (y * width + x) * 4
                redTotal += Int(data.load(fromByteOffset: offset, as: UInt8.self))
                greenTotal += Int(data.load(fromByteOffset: offset + 1, as: UInt8.self))
                blueTotal += Int(data.load(fromByteOffset: offset + 2, as: UInt8.self))
            }
        }
        let count = width * height
        let avgRed = redTotal / count
        let avgGreen = greenTotal / count
        let avgBlue = blueTotal / count
        
        return UIColor(red: CGFloat(avgRed) / 255.0, green: CGFloat(avgGreen) / 255.0, blue: CGFloat(avgBlue) / 255.0, alpha: 1)
    }
    
    var diskSizeInBytes: Int {
        guard let cgImage = self.cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
