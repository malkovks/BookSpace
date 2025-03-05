//
// File name: ReadLaterView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 03.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct ReadLaterView: View {
    @Environment(\.modelContext) private var modelContext
    var updateRightButtons: (_ buttons: AnyView) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Text("Read Later")
                    .font(.headline)
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .onAppear {
                
                //must be buttons for navigation
            }
        }
    }
}
