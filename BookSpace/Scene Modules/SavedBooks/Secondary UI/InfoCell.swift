//
// File name: InfoCell.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 08.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct InfoCell: View {
    let icon: String
    let title: String
    let font: Font
    
    init(_ icon: String, _ title: String, font: Font = .subheadline) {
        self.icon = icon
        self.title = title
        self.font = font
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            Text(title)
                .font(font)
        }
    }
}
