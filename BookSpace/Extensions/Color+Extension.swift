//
// File name: Color+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 28.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

extension Color {
    static var colorBackground: Color {
        return Color(uiColor: #colorLiteral(red: 0.8821390867, green: 0.9652094245, blue: 0.9663104415, alpha: 1))
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r,g,b: UInt64
        switch hex.count {
        case 6 : (r,g,b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default: (r,g,b) = (255,255,255)
        }
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255)
    }
    
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
    
    func hexString() -> String {
        let components = UIColor(self)?.cgColor.components ?? [1,1,1]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    

}
