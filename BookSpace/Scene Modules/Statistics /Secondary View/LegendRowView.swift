//
// File name: LegendRowView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 05.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct LegendRowView: View {
    let stat: BookStat
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            Circle()
                .fill(stat.color)
                .frame(width: 16, height: 16)
            
            VStack(alignment: .leading) {
                Text(stat.category.title)
                    .font(.subheadline)
                
                Text("\(stat.count) books (\(Int(stat.percentage * 100))%)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? stat.color.opacity(0.2) : Color.clear)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
    }
}
