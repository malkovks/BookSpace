//
// File name: ExpandableText.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 06.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ExpandableText: View {
    let text: String
    let lineLimit: Int = 4
    
    private let characterThreshold: Int = 200
    
    @State private var expanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .lineLimit(expanded ? nil : lineLimit)
                .font(.system(.callout, design: .serif))
                .italic()
                .multilineTextAlignment(.center)
            if text.count > characterThreshold {
                Button {
                    withAnimation {
                        expanded.toggle()
                    }
                } label: {
                    Text(expanded ? "Show less" : "Show more")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }

            }
        }
    }
}
