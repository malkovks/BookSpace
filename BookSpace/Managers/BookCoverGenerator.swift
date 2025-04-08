//
// File name: BookCoverGenerator.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 05.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import Combine

final class BookCoverGenerator {
    static let shared = BookCoverGenerator()
    
    private init() {}
    
    func generateCover(title: String, author: String?, size: CGSize = CGSize(width: 200, height: 300)) -> AnyPublisher<UIImage,Never> {
        return Future { promise in
            let image = self.createImage(title: title, author: author, size: size)
            promise(.success(image))
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    private func createImage(title: String, author: String?, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            let ctx = context.cgContext
            
            let colors: [UIColor] = [
                .systemRed,
                .systemBlue,
                .systemGreen,
                .systemPink,
                .systemPurple,
                .systemIndigo
            ]
            let color1 = colors.randomElement() ?? .systemPurple
            var color2 = colors.randomElement() ?? .systemIndigo
            
            while color2 == color1 {
                color2 = colors.randomElement() ?? .systemIndigo
            }
            
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [color1.cgColor, color2.cgColor] as CFArray,
                locations: [0.0, 1.0]
            )
            
            ctx.drawLinearGradient(
                gradient!,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            
            let titleParagraph = NSMutableParagraphStyle()
            titleParagraph.alignment = .center
            
            let titleFont = UIFont(name: "Georgia-Bold", size: 22) ?? .systemFont(ofSize: 22, weight: .bold)
            let titleAttribute: [NSAttributedString.Key : Any] = [.font : titleFont, .foregroundColor: UIColor.white, .paragraphStyle : titleParagraph]
            
            let titleString = NSAttributedString(string: title, attributes: titleAttribute)
            let titleRect = CGRect(x: 10, y: size.height / 3, width: size.width - 20, height: 100)
            titleString.draw(in: titleRect)
            
            if let author = author {
                let authorParagraph = NSMutableParagraphStyle()
                authorParagraph.alignment = .center
                
                let authorFont = UIFont(name: "HelveticaNeue-Italic", size: 14) ?? .italicSystemFont(ofSize: 14)
                let authorAttributes: [NSAttributedString.Key: Any] = [
                    .font: authorFont,
                    .foregroundColor: UIColor.white.withAlphaComponent(0.8),
                    .paragraphStyle: authorParagraph
                ]
                
                let authorString = NSAttributedString(string: author, attributes: authorAttributes)
                let authorRect = CGRect(x: 10, y: size.height - 50, width: size.width - 20, height: 30)
                authorString.draw(in: authorRect)
            }
        }
    }
}
