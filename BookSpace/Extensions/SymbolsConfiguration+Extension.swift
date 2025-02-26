//
// File name: SymbolsConfiguration+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

extension View {
    func createImage(_ name: String, fontSize: CGFloat = 24, primaryColor: Color = .black, secondaryColor: Color = Color(.darkGray)) -> some View {
        Image(systemName: name)
            .symbolRenderingMode(.palette)
            .font(.system(size: fontSize))
            .foregroundStyle(primaryColor,secondaryColor)
    }
}
