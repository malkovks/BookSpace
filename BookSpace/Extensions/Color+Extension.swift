//
// File name: Color+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 28.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

extension Color {
    var components: (hue: Double, saturation: Double, brightness: Double, opacity: Double) {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (Double(hue), Double(saturation), Double(brightness), Double(alpha))
    }
    
    var isLight: Bool {
        guard let components = UIColor(self).cgColor.components else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
    }
}
