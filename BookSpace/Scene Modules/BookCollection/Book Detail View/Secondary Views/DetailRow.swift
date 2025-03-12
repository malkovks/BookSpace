//
// File name: DetailRow.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 03.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct DetailRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
                .font(.system(.headline,design: .rounded))
                .minimumScaleFactor(0.8)
            Spacer()
            Text(value)
                .foregroundStyle(.black)
                .minimumScaleFactor(0.5)
                .fontDesign(.monospaced)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

