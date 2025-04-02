//
// File name: View+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 06.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

extension View {
    func messageBook(_ book: Book) -> String {
        let title = book.volumeInfo.title
        let author = book.volumeInfo.authors?.joined(separator: ", ") ?? ""
        let link = book.volumeInfo.canonicalVolumeLink
        return "Check out this book \"\(title)\" by \(author). You can read it here: \(link)"
    }
    
    @ViewBuilder
    func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
    
    func backgroundBlurEffect(style: UIBlurEffect.Style = .systemThickMaterialLight) -> some View {
        return background(BlurView(style: style)) 
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color = .black) -> some View {
        overlay(EdgeBorder(width: width, edges: edges)).foregroundStyle(color)
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}


