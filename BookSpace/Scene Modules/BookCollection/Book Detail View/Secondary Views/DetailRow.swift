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
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .fontDesign(.monospaced)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}
