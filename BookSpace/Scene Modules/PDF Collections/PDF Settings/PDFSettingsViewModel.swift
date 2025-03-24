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
        }
    }
}

@Observable
class PDFSettingsViewModel: ObservableObject {
    var displayMode : PDFDisplayMode = PDFDisplayMode(rawValue: UserDefaults.standard.integer(forKey: UserDefaultKeys.displayMode.key)) ?? .singlePage {
        didSet {
            UserDefaults.standard.set(displayMode.rawValue, forKey: UserDefaultKeys.displayMode.key)
        }
    }
    var displayAsBook: Bool = UserDefaults.standard.bool(forKey: UserDefaultKeys.displayAsBook.key) {
        didSet {
            UserDefaults.standard.set(displayAsBook, forKey: UserDefaultKeys.displayAsBook.key)
        }
    }
    var autoScales: Bool = UserDefaults.standard.bool(forKey: UserDefaultKeys.autoScales.key) {
        didSet {
            UserDefaults.standard.set(autoScales, forKey: UserDefaultKeys.autoScales.key)
        }
    }
    var orientation: PDFDisplayDirection = PDFDisplayDirection(rawValue: UserDefaults.standard.integer(forKey: UserDefaultKeys.orientation.key)) ?? .horizontal {
        didSet {
            UserDefaults.standard.set(orientation.rawValue, forKey: UserDefaultKeys.orientation.key)
        }
    }
    
    init(){
        UserDefaults.standard.register(defaults: [
            UserDefaultKeys.displayAsBook.key : false,
            UserDefaultKeys.autoScales.key : true,
            UserDefaultKeys.displayMode.key : 0,
            UserDefaultKeys.orientation.key : 0
        ])
    }
}
