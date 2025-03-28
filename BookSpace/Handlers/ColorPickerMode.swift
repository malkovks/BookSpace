//
// File name: ColorPickerMode.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 28.03.2025.
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
