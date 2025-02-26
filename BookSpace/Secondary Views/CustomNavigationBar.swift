//
// File name: CustomNavigationBar.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct CustomNavigationBar<LeftButton: View, RightButtons: View>: View {
    let title: String
    
    var placeholder: String = "Search"
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    let leftButton: LeftButton
    let rightButtons: RightButtons
    
    init(title: String, placeholder: String = "Search", isSearching: Binding<Bool>, searchText: Binding<String>, @ViewBuilder leftButton: () -> LeftButton, @ViewBuilder rightButtons: () ->  RightButtons) {
        self.title = title
        self.placeholder = placeholder
        self._isSearching = isSearching
        self._searchText = searchText
        self.leftButton = leftButton()
        self.rightButtons = rightButtons()
    }
    
    var body: some View {
        HStack(spacing: 15) {
            if isSearching {
                HStack(spacing: 10) {
                    createImage("magnifyingglass",fontSize: 18)
                        .padding(10)
                    TextField(placeholder, text: $searchText) {
                        
                    }
                    Button {
                        isSearching.toggle()
                        print("Search is closed")
                    } label: {
                        createImage("xmark",fontSize: 18)
                    }
                    .padding(10)
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.2))
                .clipShape(Capsule(style: .circular))
                .frame(maxWidth: .infinity,maxHeight: 80,alignment: .leading)
//                .transition(.move(edge: .top))
            } else {
                leftButton
                
                Text(title)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity,maxHeight: 80,alignment: .leading)
                HStack {
                    rightButtons
                }
            }
            
        }
        .padding(.horizontal,20)
        .background(.skyBlue)
    }
}
