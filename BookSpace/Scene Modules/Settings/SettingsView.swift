//
// File name: SettingsView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct SettingsView: View {
    var updateRightButtons: (_ buttons: AnyView) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Text("Books Collection View")
            }
            .onAppear {
                updateRightButtons(AnyView(
                    Text("No buttons")
                ))
            }
        }
    }
}

#Preview {
    SettingsView { buttons in
        
    }
}
