//
// File name: CustomSearchBar.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct CustomSearchBar: View {
    
    let placeholder: String
    @Binding var text: String
    var onCommit: () -> Void
    var onClose: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            createImage("magnifyingglass",fontSize: 18)
                .padding(10)
            TextField(placeholder, text: $text,onCommit: onCommit)
            Button {
                onClose()
            } label: {
                createImage("xmark",fontSize: 18)
            }
            .padding(10)
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(Color.red.opacity(0.2))
        .clipShape(Capsule(style: .circular))
        .transition(.move(edge: .top))
    }
}
