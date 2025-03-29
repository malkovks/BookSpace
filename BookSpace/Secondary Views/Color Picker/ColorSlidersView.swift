//
// File name: ColorSlidersView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 29.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ColorSlidersView: View {
    @Binding var selectedColor: Color
    @Binding var opacity: Double
    
    @State private var red: Double = 1.0
    @State private var green: Double = 0.0
    @State private var blue: Double = 0.0

    var body: some View {
        VStack(spacing: 20) {
            
            ColorSliderRow(title: "Red", value: $red, color: .red)
            ColorSliderRow(title: "Green", value: $green, color: .green)
            ColorSliderRow(title: "Blue", value: $blue, color: .blue)
            
            
            ColorSliderRow(title: "Alpha", value: $opacity, color: .gray)
        }
        .padding()
        .onAppear {
            
            let uiColor = UIColor(selectedColor)
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            red = Double(r)
            green = Double(g)
            blue = Double(b)
            opacity = Double(a)
        }
        
        .onChange(of: red) { _,_ in updateColor() }
        .onChange(of: green) { _,_ in updateColor() }
        .onChange(of: blue) { _,_ in updateColor() }
        .onChange(of: opacity) { _,_ in updateColor() }
    }
    
    private func updateColor() {
        selectedColor = Color(red: red, green: green, blue: blue)
    }
}

struct ColorSliderRow: View {
    let title: String
    @Binding var value: Double
    let color: Color
    var range: ClosedRange<Double> = 0...1

    var body: some View {
        HStack {
            
            Text(title)
                .frame(width: 50, alignment: .leading)
            
            
            Slider(value: $value, in: range)
                .accentColor(color)
            
            TextField("", value: $value, formatter: NumberFormatter.rgbFormatter)
                .frame(width: 60)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
        }
    }
}
