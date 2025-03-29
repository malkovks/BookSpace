//
// File name: Untitled.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct CustomColorPickerView: View {
    @Binding var color: Color
    var goBack: () -> Void
    
    
    @State private var selectedMode: ColorPickerMode = .spectrum
    @State private var opacity: Double = 1.0
    
    @State private var colorLocation: CGPoint = CGPoint(x: 20, y: 20)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Picker("Pick a mode", selection: $selectedMode) {
                    ForEach(ColorPickerMode.allCases, id: \.self) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                TabView(selection: $selectedMode) {
                    
                    ColorGridView(selectedColor: $color)
                        .tag(ColorPickerMode.grid)
                        .frame(minHeight: 100, maxHeight: 400)
                    
                    
                    ColorSpectrumView(selectedColor: $color, opacity: $opacity)
                        .tag(ColorPickerMode.spectrum)
                        .frame(height: 250)
                    
                    
                    ColorSlidersView(selectedColor: $color, opacity: $opacity)
                        .tag(ColorPickerMode.sliders)
                        .frame(minHeight: 100)
                }
                .padding(20)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                if selectedMode != .sliders {
                    OpacitySlider(opacity: $opacity)
                }
                
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(opacity))
                    .frame(height: 50)
                    .overlay(
                        Text("Preview")
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                    .padding()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        goBack()
                    } label: {
                        createImage("chevron.left", fontSize: 20, primaryColor: .black)
                    }
                }
            }
            .navigationTitle("Color Picker")
            .background(Color.secondary.opacity(0.2))
        }
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
    CustomColorPickerView(color: .constant(.warningYellow)){
        
    }
}
