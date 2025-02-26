//
// File name: Untitled.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                contentView
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .transition(.opacity)
                VStack {
                    CustomNavigationBar(title: coordinator.selectedCategory.title, isSearching: .constant(false), searchText: .constant("")) {
                        Button {
                            withAnimation {
                                coordinator.isSideMenuVisible.toggle()
                                print("Must open menu")
                            }

                        } label: {
                            createImage("menucard.fill")
                        }
                    } rightButtons: {
                        HStack {
                            Button {
                                print("Must open search")
                            } label: {
                                createImage("magnifyingglass")
                            }
                            
                            Button {
                                print("sort button")
                            } label: {
                                createImage("line.3.horizontal.decrease.circle")
                            }
                        }
                    }
                }
                if coordinator.isSideMenuVisible {
                    SideMenuView(selectedCategory: $coordinator.selectedCategory) {
                        withAnimation {
                            coordinator.isSideMenuVisible.toggle()
                        }
                    }
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch coordinator.selectedCategory {
        case .main:
            BookCollectionView()
        case .savedBooks:
            SavedBooksView()
        case .settings:
            SettingsView()
        }
    }
}

