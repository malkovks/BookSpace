//
// File name: FilterBooksView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 01.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct FilterBooksView: View {
    
    @Binding var filter: FilterCategories
    
    var onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing,spacing: 5) {
            Button {
                withAnimation {
                    onClose()
                }
            } label: {
                createImage("xmark")
            }
            .padding([.top,.trailing], 5)
            List(FilterCategories.allCases, id: \.self) { category in
                HStack {
                    Text(category.title)
                    Spacer()
                    if self.filter == category {
                        createImage("checkmark.circle")
                    }
                }
                .onTapGesture {
                    filter = category
                    withAnimation {
                        onClose()
                    }
                }
                .listRowBackground(Color.clear)
                
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .background(Color.white)
    }
}
