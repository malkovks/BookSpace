//
// File name: UserDefaults+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 28.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.
import Foundation

extension UserDefaults {
    static func registerPDFDefaults() {
        PDFSettingsViewModel.registerDefaults()
    }
    
    static func registerSettingsDefaults() {
        
    }
}

