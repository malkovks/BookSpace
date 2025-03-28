//
// File name: Untitled.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct CustomColorPickerView: View {
//    @Environment(\.dismiss) var dismiss
    @Binding var color: Color
    
    @State private var selectedMode: ColorPickerMode = .spectrum
    @State private var opacity: Double = 1.0
    @State private var colorLocation: CGPoint = CGPoint(x: 20, y: 20)
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Pick a mode", selection: $selectedMode){
                    ForEach(ColorPickerMode.allCases, id: \.self) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                Group {
                    switch selectedMode {
                    case .grid:
                        ColorGridView(selectedColor: $color)
                    case .spectrum:
                        ColorSpectrumView(selectedColor: $color,opacity: $opacity)
                    case .sliders:
                        ColorSlidersView(selectedColor: $color, opacity: $opacity)
                    }
                }
                .frame(height: 250)
                
                OpacitySlider(opacity: $opacity)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(opacity))
                    .animation(.linear(duration: 0.2), value: color)
                    .frame(height: 50)
                    .padding()
                    .id("colorPreview\(color.description)\(opacity)")
            }
            
            .padding()
        }
    }
}

struct ColorGridView: View {
    @Binding var selectedColor: Color
    let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .orange]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
            ForEach(colors, id: \.self) { color in
                color.frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        
        }
        .padding()
    }
}

struct ColorSpectrumView: View {
    @Binding var selectedColor: Color
    @Binding var opacity: Double
    @State var colorLocation: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                Rectangle()
                
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: (0...10).map { i in
                                Color(hue: Double(i) / 10.0, saturation: 1, brightness: 1)
                            }),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.white.opacity(0.3), .clear, .black.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newX = min(max(value.location.x, 0), size.width)
                            let newY = min(max(value.location.y, 0), size.height)
                            let newLocation = CGPoint(x: newX, y: newY)
                            
                            
                            colorLocation = newLocation
                            selectedColor = getColor(at: colorLocation, in: size)
                        }
                    )
                
                Circle()
                    .fill(selectedColor.opacity(opacity))
                    .animation(.linear(duration: 0.2),value: selectedColor)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(width: 20, height: 20)
                    .position(colorLocation)
                    .shadow(radius: 3)
            }
            .onAppear {
                colorLocation = calculateLocation(for: selectedColor, in: size)
            }
        }
    }
    
    private func getColor(at point: CGPoint, in size: CGSize) -> Color {
        let normalizedX = min(max(point.x, 0), size.width) / size.width
        let normalizedY = min(max(point.y, 0), size.height) / size.height
        
        return Color(
            hue: normalizedX,
            saturation: 1,
            brightness: 1 - normalizedY,
            opacity: opacity
        )
    }
    
    private func calculateLocation(for color: Color,in size: CGSize) -> CGPoint {
        let components = color.components
        return CGPoint(x: components.hue * size.width, y: (1 - components.brightness) * size.height)
    }
}


struct ColorSlidersView: View {
    @Binding var selectedColor: Color
    @Binding var opacity: Double
    
    @State private var red: Double = 1.0
    @State private var green: Double = 0.0
    @State private var blue: Double = 0.0
    
    var body: some View {
        VStack {
            ColorSlider(value: $red, color: .red)
            ColorSlider(value: $green, color: .green)
            ColorSlider(value: $blue, color: .blue)
        }
        .onChange(of: red + green + blue) { _ ,_ in
            selectedColor = Color(red: red, green: green, blue: blue)
        }
        .padding()
        
    }
    
    private func updateColor() {
        selectedColor = Color(red: .init(red), green: .init(green), blue: .init(blue))
    }
}

struct SliderRow: View {
    let title: String
    
    @Binding var value: Double
    
    var body: some View {
        HStack {
            Text(title)
            Slider(value: $value, in: 0...1)
            Text("\(Int(value * 255))")
        }
    }
}

struct ColorSlider: View {
    @Binding var value: Double
    let color: Color
    var body: some View {
        HStack {
            color.frame(width: 30, height: 30)
            Slider(value: $value, in: 0...1)
        }
    }
}

struct OpacitySlider: View {
    @Binding var opacity: Double
    
    var body: some View {
        VStack {
            Text("Opacity: \(Int(opacity * 100))%")
            Slider(value: $opacity, in: 0...1)
        }
        .padding()
    }
}

#Preview {
    CustomColorPickerView(color: .constant(.warningYellow))
}
