//
// File name: CircleView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 13.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct CircleView: View {
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 3)
            if isSelected {
                Circle()
                    .scale(0.7)
                    .fill(Color.black)
                    .animation(.interactiveSpring.delay(03), value: isSelected)
            }
        }
        .frame(width: 30, height: 30, alignment: .center)
    }
}
