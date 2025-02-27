//
// File name: SavedBooksView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct SavedBooksView: View {
    var updateRightButtons: (_ buttons: AnyView) -> Void

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Text("Books Collection View")
            }
            .onAppear {
                updateRightButtons(AnyView(
                HStack {
                    Button {
                        print("heart button")
                    } label: {
                        createImage("heart")
                    }
                }))
            }
        }
    }
}

#Preview {
    SavedBooksView { buttons in
        
    }
}
