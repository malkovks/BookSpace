//
// File name: BooksWidgetView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 11.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import WidgetKit

struct BooksWidgetView: View {
    var entry: BooksEntry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            VStack(alignment: .leading,spacing: 8) {
                Text("📚 Books")
                    .font(.headline)
                VStack {
                    Spacer()
                    WidgetRow(title: "Favorites", count: entry.favoriteCount)
                    Divider()
                    WidgetRow(title: "Planned", count: entry.plannedCount)
                }
                .background(Color.skyBlue)
                .clipShape(.rect(cornerRadius: 8))
                
            }
            .padding(.all, 8)
        case .systemSmall:
            VStack(alignment: .center,spacing: 4) {
                Text("📚 Books")
                    .font(.system(size: 18,weight: .medium))
                SmallWidgerRow(count: entry.favoriteCount, secondCount: entry.plannedCount)
            }
            .padding()
        case .systemLarge, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct WidgetRow: View {
    var title: String
    var count: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.leading, 4)
            Spacer()
            Text("\(count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.trailing, 4)
        }
        .padding(4)
    }
}

struct SmallWidgerRow: View {
    var count: Int
    var secondCount: Int
    
    var body: some View {
        HStack {
            Text("⭐️")
            Text("\(count)")
                .font(.system(size: 14,weight: .regular))
                .foregroundStyle(.secondary)
            Spacer()
            Text("⏰")
            Text("\(secondCount)")
                .font(.system(size: 14,weight: .regular))
                .foregroundStyle(.secondary)
        }
    }
}
