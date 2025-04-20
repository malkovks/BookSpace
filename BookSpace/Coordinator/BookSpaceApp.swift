//
// File name: BookSpaceApp.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import SwiftData

@main
struct BookSpaceApp: App {
    @StateObject private var settings: SettingsViewModel
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var network = NetworkMonitor()
    
    private static let sharedModelContainer: ModelContainer = {
        let schema = Schema([SavedBooks.self,SavedPDF.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()
    
    init() {
        _settings = StateObject(
            wrappedValue: SettingsViewModel(
                modelContext: Self.sharedModelContainer.mainContext
            )
        )
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(modelContext: Self.sharedModelContainer.mainContext)
                .environmentObject(coordinator)
                .environmentObject(settings)
                .environmentObject(network)
                .preferredColorScheme(settings.appearanceMode == .light ? .light : (settings.appearanceMode == .dark ? .dark : nil))
        }
    }
}
