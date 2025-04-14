//
// File name: ColorGridView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 29.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

import SwiftUI

struct ColorGridView: View {
    @Binding var selectedColor: Color
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 8)
    
    private var colors: [[Color]] {
        var result = Array(repeating: Array(repeating: Color.white, count: 8), count: 8)
        
        
        for col in 0..<8 {
            let step = Double(col) / 7.0
            let brightness = 1.0 - 0.8 * step
            result[0][col] = Color(hue: 0, saturation: 0, brightness: brightness)
        }
        
        
        
        for row in 1..<8 {
            for col in 0..<8 {
                let hue = Double(col) / 8.0
                
                let brightness = 1.0 - (Double(row) / 7.0) * 0.9
                result[row][col] = Color(hue: hue, saturation: 1.0, brightness: brightness)
            }
        }
        
        return result
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<8, id: \.self) { row in
                ForEach(0..<8, id: \.self) { col in
                    let color = colors[row][col]
                    colorButton(for: color)
                }
            }
        }
        .padding()
    }
    
    private func colorButton(for color: Color) -> some View {
        Button {
            selectedColor = color
        } label: {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
                .overlay(
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .opacity(selectedColor == color ? 1 : 0)
                )
        }
    }
}
