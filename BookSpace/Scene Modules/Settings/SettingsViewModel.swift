//
// File name: SettingsViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 14.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

@Observable
class SettingsViewModel: ObservableObject {
    var selectedFont: String = "System" {
        didSet { updateIfneeded(oldValue, selectedFont, key: SettingsKeys.selectedFont) }
    }
    var headerFontSize: CGFloat = 24 {
        didSet { updateIfneeded(oldValue , headerFontSize, key: SettingsKeys.headerFontSize)}
    }
    
    var backgroundColor: Color = .skyBlue {
        
        didSet {
            let hexColor = backgroundColor.hexString()
            updateIfneeded(oldValue.hexString(), hexColor, key: SettingsKeys.backgroundColor)
        }
    }
    var isCameraAccessAllowed: Bool = true
    var appearanceMode: AppearanceMode = .automatic
    
    
    enum AppearanceMode: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        
        case light, dark, automatic
    }
    
    private enum SettingsKeys {
        static let selectedFont = "selectedFont"
        static let headerFontSize = "headerFontSize"
        static let backgroundColor = "backgroundColor"
        static let isCameraAccessAllowed = "isCameraAccessAllowed"
        static let appearanceMode = "appearanceMode"
    }
    
    private func updateIfneeded<T: Equatable>(_ old: T, _ new: T, key: String) {
        if old != new {
            UserDefaults.standard.set(new, forKey: key)
        }
    }
}
