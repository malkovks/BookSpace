//
// File name: SideMenuView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

enum SideMenuCategories: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case main
    case savedBooks
    case readLater
    case settings
    
    var title: String {
        switch self {
        case .main:
            return "Main"
        case .savedBooks:
            return "Saved"
        case .settings:
            return "Settings"
        case .readLater:
            return "Read Later"
        }
    }
    
    var icon: Image {
        switch self {
        case .main:
            return Image(systemName: "book.pages")
        case .savedBooks:
            return Image(systemName: "heart.square.fill")
        case .settings:
            return Image(systemName: "gear.badge")
        case .readLater:
            return Image(systemName: "bookmark.fill")
        }
    }
}

struct SideMenuView: View {
    @Binding var selectedCategory: SideMenuCategories
    var onMenuClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Spacer()
                Button {
                    onMenuClose()
                } label: {
                    Image(systemName: "xmark")
                }
                .padding(.trailing, 20)
                .foregroundStyle(.black)
                .font(.system(size: 20))
            }
            ForEach(SideMenuCategories.allCases,id: \.id) { category in
                Button {
                    if selectedCategory == category {
                        onMenuClose()
                    } else {
                        selectedCategory = category
                        onMenuClose()
                    }
                } label: {
                    HStack {
                        category.icon
                        Text(category.title)
                            .font(.subheadline)
                    }
                    .padding()
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity,alignment: .leading)
                }
                .foregroundStyle(.black)
                .background(selectedCategory == category ? .paperYellow : .clear)
                .clipShape(.capsule(style: .circular))
                
            }
    
            Spacer()
            
        }
        .padding(.vertical, 20)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.75 ,alignment: .leading)
        .background(Color(.lightGray))
        .shadow(radius: 5)
    }
}

#Preview {
    SideMenuView(selectedCategory: .constant(.main), onMenuClose: { })
}
