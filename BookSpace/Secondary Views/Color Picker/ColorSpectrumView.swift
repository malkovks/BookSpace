//
// File name: ColorSpectrumView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 29.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ColorSpectrumView: View {
    @Binding var selectedColor: Color
    @Binding var opacity: Double
    @State private var colorLocation: CGPoint = .zero
    
    private let gradientColors: [Color] = [.white,.white,.purple, .pink,.red, .orange, .yellow, .green, .blue, .black]
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        
                        )
                        .blendMode(.multiply)
                    )
                    
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .blendMode(.multiply)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let newLocation = CGPoint(
                                    x: min(max(value.location.x, 0), size.width),
                                    y: min(max(value.location.y, 0), size.height)
                                )
                                colorLocation = newLocation
                                selectedColor = getColor(at: newLocation, in: size)
                            }
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                    }
                    
                
                Circle()
                    .fill(selectedColor.opacity(opacity))
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .frame(width: 24, height: 24)
                    .position(colorLocation)
                    .shadow(radius: 3)
            }
            .padding(.horizontal,10)
            .onAppear {
                colorLocation = calculateLocation(for: selectedColor, in: size)
            }
            .onChange(of: opacity) { _, newValue in
                selectedColor = getColor(at: colorLocation, in: size)
            }
        }
    }
    
    
    
    private func getColor(at point: CGPoint, in size: CGSize) -> Color {
        let normalizedX = min(max(point.x / size.width, 0), 1)
        let normalizedY = min(max(point.y / size.height, 0), 1)
        
        let gradientPosition = normalizedX * CGFloat(gradientColors.count - 1)
        let index = min(Int(gradientPosition), gradientColors.count - 2)
        let progress = gradientPosition - CGFloat(index)
        
        let startColor = UIColor(gradientColors[index])
        let endColor = UIColor(gradientColors[index + 1])
        
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let red = startRed + (endRed - startRed) * progress
        let green = startGreen + (endGreen - startGreen) * progress
        let blue = startBlue + (endBlue - startBlue) * progress
        
        let brightness = 1 - normalizedY
        let finalRed = red * brightness
        let finalGreen = green * brightness
        let finalBlue = blue * brightness
        
        return Color(
            .sRGB,
            red: Double(finalRed),
            green: Double(finalGreen),
            blue: Double(finalBlue),
            opacity: opacity
        )
    }
    
    private func calculateLocation(for color: Color, in size: CGSize) -> CGPoint {
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let targetColor = UIColor(color) ?? .white
        var closestIndex = 0
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for (index, gradientColor) in gradientColors.enumerated() {
            let distance = colorDistance(targetColor, UIColor(gradientColor))
            if distance < minDistance {
                minDistance = distance
                closestIndex = index
            }
        }
        
        let x = CGFloat(closestIndex) / CGFloat(gradientColors.count - 1) * size.width
        let brightness = max(red, green, blue)
        let y = (1 - brightness) * size.height
        
        return CGPoint(x: x, y: y)
    }
    
    private func colorDistance(_ color1: UIColor, _ color2: UIColor) -> CGFloat {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return sqrt(pow(r1 - r2, 2) + pow(g1 - g2, 2) + pow(b1 - b2, 2))
    }
}
