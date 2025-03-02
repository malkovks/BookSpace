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
        .padding()
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.4), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.1), radius: 4,x: 0,y: 2)
    }
}
