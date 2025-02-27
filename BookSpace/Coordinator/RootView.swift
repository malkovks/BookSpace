//
// File name: Untitled.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    @State private var rightButtons: AnyView = AnyView(EmptyView())
    @State private var isNavigationBarHidden: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                contentView
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .transition(.opacity)
                VStack {
                    CustomNavigationBar(title: coordinator.selectedCategory.title) {
                        Button {
                            withAnimation {
                                coordinator.isSideMenuVisible.toggle()
                            }
                            
                        } label: {
                            createImage("menucard.fill")
                        }
                    } rightButtons: {
                        rightButtons
                    }
                    .opacity(isNavigationBarHidden ? 0 : 1)
                }
                if coordinator.isSideMenuVisible {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                coordinator.isSideMenuVisible = false
                            }
                        }
                }
                
                SideMenuView(selectedCategory: $coordinator.selectedCategory) {
                    withAnimation {
                        coordinator.isSideMenuVisible.toggle()
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.75)
                .offset(x: coordinator.isSideMenuVisible ? 0 : -UIScreen.main.bounds.width * 0.75)
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
            .animation(.easeInOut, value: coordinator.isSideMenuVisible)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch coordinator.selectedCategory {
        case .main:
            BookCollectionView { buttons in
                rightButtons = AnyView(buttons)
            } needToHideNavigation: { isHidden in
                isNavigationBarHidden = isHidden
            }

        case .savedBooks:
            SavedBooksView { buttons in
                rightButtons = AnyView(buttons)
            }
        case .settings:
            SettingsView { buttons in
                rightButtons = AnyView(buttons)
            }
        }
    }
}

