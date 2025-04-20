//
// File name: RootView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData
import Combine



struct RootView: View {
    var modelContext: ModelContext
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var settings: SettingsViewModel
    @EnvironmentObject private var networkManager: NetworkMonitor
    
    @State private var rightButtons: AnyView = AnyView(EmptyView())
    @State private var isNavigationBarHidden: Bool = false
    @State private var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                settings.backgroundColor.ignoresSafeArea()
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
                    .environmentObject(settings)
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
            BookCollectionCoordinator(modelContext: modelContext)
                .makeView(rightButtons: {
                    rightButtons = $0
                }, needToHideNavigation: {
                    isNavigationBarHidden = $0
                })
            .environmentObject(networkManager)
            .environmentObject(settings)

        case .savedBooks:
            SavedBooksView(viewModel: SavedBooksViewModel(modelContext: modelContext)) { buttons in
                rightButtons = AnyView(buttons)
            } navigateToBookCollection: {
                coordinator.selectedCategory = .main
            }
            .environmentObject(settings)
        
        case .readLater:
            ReadLaterView(viewModel: ReadLaterViewModel(modelContext: modelContext), updateRightButtons: { buttons in
                rightButtons = buttons
            }, navigateToBookCollection: {
                coordinator.selectedCategory = .main
            })
        case .pdfLibrary:
            PDFLibraryView(viewModel: PDFLibraryViewModel(modelContext: modelContext)) {
                rightButtons = $0
            }
        case .statistics:
            CircleStatView(viewModel: CircleStatViewModel(bookManager: BooksDataManager(context: modelContext))) {
                rightButtons = $0
            } navigate: {
                navigateToSelectedCategory($0)
            }
        case .settings:
            SettingsCoordinator()
                .makeView(
                    settings: settings,
                    rightButtons: {
                rightButtons = $0
            })
            
        }
        
    }
    
    private func navigateToSelectedCategory(_ category: BookStat.BookCategory){
        Just(())
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { _ in
                switch category {
                case .favorite:
                    coordinator.selectedCategory = .savedBooks
                case .planned:
                    coordinator.selectedCategory = .readLater
                case .read:
                    break
                }
            }
            .store(in: &cancellable)
    }
}
