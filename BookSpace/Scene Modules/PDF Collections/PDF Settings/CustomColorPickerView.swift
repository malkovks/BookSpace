//
// File name: Untitled.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

enum ColorPickerMode: CaseIterable {
    case grid
    case spectrum
    case sliders
    
    var title: String {
        switch self {
        case .grid:
            return "Grid"
        case .spectrum:
            return "Spectrum"
        case .sliders:
            return "Sliders"
        }
    }
}

struct CustomColorPickerView: View {
    @State private var selectedMode: ColorPickerMode = .spectrum
    @State private var selectedColor: Color = .yellow
    @State private var opacity: Double = 1.0
    @State private var colorLocation: CGPoint = CGPoint(x: 20, y: 20)
    
    var body: some View {
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
                    ColorGridView(selectedColor: $selectedColor)
                case .spectrum:
                    ColorSpectrumView(selectedColor: $selectedColor,opacity: $opacity)
                case .sliders:
                    ColorSlidersView(selectedColor: $selectedColor, opacity: $opacity)
                }
            }
            .frame(height: 250)
            
            OpacitySlider(opacity: $opacity)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(selectedColor.opacity(opacity))
                .frame(height: 50)
                .padding()
        }
        .padding()
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
    
    let spectrumImage = Image("spectrum")
    
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
                            gradient: Gradient(colors: [.white, .clear, .black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let newX = min(max(value.location.x, 0), size.width)
                            let newY = min(max(value.location.y, 0), size.height)
                            
                            colorLocation = CGPoint(x: newX, y: newY)
                            selectedColor = getColor(at: colorLocation, in: size)
                        }
                    )
                
                Circle()
                    .fill(selectedColor)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(width: 20, height: 20)
                    .position(colorLocation)
                    .shadow(radius: 3)
            }
            .onAppear {
                colorLocation = getInitialLocation(for: selectedColor, in: geometry.size)
            }
        }
    }
    
    private func getColor(at point: CGPoint, in size: CGSize) -> Color {
        let hue = point.x / size.width
        let brightness = 1 - (point.y / size.height)
        return Color(UIColor(hue: hue, saturation: 1, brightness: brightness, alpha: 1))
    }
    
    
    private func getInitialLocation(for color: Color, in size: CGSize) -> CGPoint {
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return CGPoint(x: hue * size.width, y: (1 - brightness) * size.height)
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
    return CustomColorPickerView()
}
