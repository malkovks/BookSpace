//
// File name: CustomSearchBar.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct CustomSearchBar: View {
    
    var searchResults: [String] = []
    let placeholder: String
    @Binding var text: String
    var onCommit: () -> Void
    var onClose: () -> Void
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.4)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        onClose()
                    }
                }
            
            VStack(spacing: 20) {
                HStack(spacing: 15) {
                    createImage("magnifyingglass",fontSize: 18)
                        .padding(10)
                    TextField(placeholder, text: $text,onCommit: onCommit)
                    Button {
                        onClose()
                    } label: {
                        createImage("xmark",fontSize: 18)
                    }
                    .padding(10)
                }
                .padding()
                .frame(maxWidth: .infinity,maxHeight: 80,alignment: .leading)
                .background(.skyBlue)
                .foregroundStyle(.red)
                
                List(searchResults, id: \.self) { result in
                    Button {
                        print("selected result: \(result)")
                    } label: {
                        Text(result)
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: 300)
                .background(.white)
                .transition(.opacity)
                Spacer()
            }
        }
    }
}
