//
// File name: PieSegment.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 05.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct PieSegment: View {
    let data: BookStat
    let isSelected: Bool
    let onSelect: () -> Void
    @State private var localSelected: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: data.angleRange.start,
                    endAngle: data.angleRange.end,
                    clockwise: false)
                path.closeSubpath()
                    
            }
            .fill(data.color)
            .overlay {
                Path { path in
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: data.angleRange.start,
                        endAngle: data.angleRange.end,
                        clockwise: false)
                    path.closeSubpath()
                }
                .stroke(isSelected || localSelected ? Color.white : Color.black, lineWidth: isSelected || localSelected ? 4 : 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected || localSelected)
            .onTapGesture {
                localSelected = true
                onSelect()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    localSelected = false
                })
            }
            .overlay {
                percentageText(in: geometry)
                    
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    @ViewBuilder private func percentageText(in geometry: GeometryProxy) -> some View {
        let radius = min(geometry.size.width, geometry.size.height) / 2
        let middleAngle = (data.angleRange.start + data.angleRange.end) / 2
        let textRadius = radius * 0.7
        
        let x = textRadius * cos(CGFloat(middleAngle.radians))
        let y = textRadius * sin(CGFloat(middleAngle.radians))
        
        Text("\(Int(data.percentage * 100))%")
            .font(.system(size: min(radius / 5, 14), weight: .bold))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 1)
            .frame(width: 40, height: 20)
            .background(Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .position(x: geometry.size.width / 2 + x, y: geometry.size.height / 2 + y)
            .opacity(data.percentage > 0.15 ? 1 : 0) 
    }
}
