//
// File name: StarRatingView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 08.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : .gray)
                    .onTapGesture {
                        withAnimation {
                            rating = index
                        }
                    }
            }
        }
    }
}
