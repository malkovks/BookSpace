//
// File name: NetworkManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 18.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.objectWillChange.send()
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

