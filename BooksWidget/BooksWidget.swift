//
// File name: BooksWidget.swift
// Package: BooksWidget
//
// Created by Malkov Konstantin on 11.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import WidgetKit
import SwiftUI
import SwiftData

struct BooksWidget: Widget {
    let kind: String = "malkov.ks.BookSpace.BooksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BooksTimelineProvider(modelContext: ModelContext.preview)) { entry in
            BooksWidgetView(entry: entry)
        }
        .configurationDisplayName("Books")
        .description("Displaying counts of favorites and planned to read books")
        .supportedFamilies([.systemSmall,.systemMedium])
    }
}


