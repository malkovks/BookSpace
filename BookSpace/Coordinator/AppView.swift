//
// File name: AppView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 16.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

struct AppView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var settings = SettingsViewModel()
    @StateObject private var network = NetworkMonitor()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([SavedBooks.self,SavedPDF.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()
    
    var body: some View {
        RootView(modelContext: sharedModelContainer.mainContext)
            .environmentObject(coordinator)
            .environmentObject(settings)
            .environmentObject(network)
    }
}
