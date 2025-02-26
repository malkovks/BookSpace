//
// File name: ContentView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 22.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI
import SwiftData

struct BookCollectionView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = BookCollectionViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Text("Books Collection View")
//                Group {
//                    switch viewModel.selectedCategory {
//                    case .main:
//                        BookCollectionView()
//                    case .savedBooks:
//                        SavedBooksView()
//                    case .settings:
//                        SettingsView()
//                    }
//                }
//                .frame(maxWidth: .infinity,maxHeight: .infinity)
//                .transition(.opacity)
//                
//                VStack {
//                    CustomNavigationBar(title: "Main Screen", isSearching: $viewModel.isSearchFieldVisible, searchText: $viewModel.searchText) {
//                        Button {
//                            withAnimation {
//                                viewModel.isSideMenuVisible.toggle()
//                                print("Must open menu")
//                            }
//
//                        } label: {
//                            createImage("menucard.fill")
//                        }
//                    } rightButtons: {
//                        HStack {
//                            Button {
//                                viewModel.isSearchFieldVisible.toggle()
//                                print("Must open search")
//                                print(viewModel.isSearchFieldVisible)
//                            } label: {
//                                createImage("magnifyingglass")
//                            }
//                            
//                            Button {
//                                print("sort button")
//                            } label: {
//                                createImage("line.3.horizontal.decrease.circle")
//                            }
//                        }
//                    }
//
//                    Spacer()
//                }
//                if viewModel.isSideMenuVisible {
//                    SideMenuView(selectedCategory: $viewModel.selectedCategory){
//                        withAnimation {
//                            viewModel.isSideMenuVisible.toggle()
//                        }
//                    }
//                        .frame(width: 250)
//                        .transition(.move(edge: .leading))
//                        .zIndex(2)
//                }


            }
            .animation(.easeInOut, value: viewModel.isSideMenuVisible)
            .animation(.easeInOut, value: viewModel.isSearchFieldVisible)
        }
    }
}

#Preview {
    BookCollectionView()
        .modelContainer(for: Item.self, inMemory: true)
}
