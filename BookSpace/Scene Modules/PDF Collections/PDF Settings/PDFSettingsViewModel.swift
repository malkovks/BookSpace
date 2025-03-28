//
// File name: PDFSettingsViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 18.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import PDFKit

enum UserDefaultKeys {
    case displayAsBook
    case autoScales
    case displayMode
    case orientation
    case color
    
    var key: String {
        switch self {
        case .displayAsBook:
            return "settings.displayAsBook"
        case .autoScales:
            return "settings.autoScales"
        case .displayMode:
            return "settings.displayMode"
        case .orientation:
            return "settings.orientation"
        case .color:
            return "settings.color"
        }
    }
}

@Observable
class PDFSettingsViewModel: ObservableObject {
    var displayMode: PDFDisplayMode {
        didSet {
            UserDefaults.standard.set(displayMode.rawValue, forKey: UserDefaultKeys.displayMode.key)
        }
    }
    
    var displayAsBook: Bool {
        didSet {
            UserDefaults.standard.set(displayAsBook, forKey: UserDefaultKeys.displayAsBook.key)
        }
    }
    
    var autoScales: Bool {
        didSet {
            UserDefaults.standard.set(autoScales, forKey: UserDefaultKeys.autoScales.key)
        }
    }
    
    var orientation: PDFDisplayDirection {
        didSet {
            UserDefaults.standard.set(orientation.rawValue, forKey: UserDefaultKeys.orientation.key)
        }
    }
    
    var backgroundColor: Color {
        didSet {
            if let data = try? JSONEncoder().encode(CodableColor(color: backgroundColor)) {
                UserDefaults.standard.set(data, forKey: UserDefaultKeys.color.key)
            }
        }
    }
    
    var navigationPath: NavigationPath = .init()
    
    init() {
        PDFSettingsViewModel.registerDefaults()
        
        self.displayMode = PDFDisplayMode(rawValue: UserDefaults.standard.integer(forKey: UserDefaultKeys.displayMode.key)) ?? .singlePage
        self.displayAsBook = UserDefaults.standard.bool(forKey: UserDefaultKeys.displayAsBook.key)
        self.autoScales = UserDefaults.standard.bool(forKey: UserDefaultKeys.autoScales.key)
        self.orientation = PDFDisplayDirection(rawValue: UserDefaults.standard.integer(forKey: UserDefaultKeys.orientation.key)) ?? .horizontal

        if let data = UserDefaults.standard.data(forKey: UserDefaultKeys.color.key),
           let codableColor = try? JSONDecoder().decode(CodableColor.self, from: data) {
            self.backgroundColor = codableColor.color
        } else {
            self.backgroundColor = .paperYellow
        }
    }
    
    static func registerDefaults() {
        if !UserDefaults.standard.bool(forKey: "defaultsRegistered") {
            let defaultColorData = try? JSONEncoder().encode(CodableColor(color: .paperYellow))
            
            UserDefaults.standard.register(defaults: [
                UserDefaultKeys.displayAsBook.key: false,
                UserDefaultKeys.autoScales.key: true,
                UserDefaultKeys.displayMode.key: 0,
                UserDefaultKeys.orientation.key: 0,
                UserDefaultKeys.color.key: defaultColorData as Any
            ])
            
            UserDefaults.standard.set(true, forKey: "defaultsRegistered")
        }
    }
}


