//
// File name: ModelContext+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 11.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftData

extension ModelContext {
    static var preview: ModelContext {
        let schema = Schema([SavedBooks.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContext(ModelContainer(for: schema, configurations: [modelConfiguration]))
    }
}
