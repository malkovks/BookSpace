//
// File name: LinkRow.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 03.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct LinkRow: View {
    var title: String
    var url: String
    var systemImage: String
    
    var body: some View {
        HStack {
            Spacer()
            Link(title, destination: URL(string: url)!)
                .foregroundStyle(Color(uiColor: .blue))
            Image(systemName: systemImage)
                .foregroundStyle(Color(uiColor: .blue))
            Spacer()
            
        }
    }
}
