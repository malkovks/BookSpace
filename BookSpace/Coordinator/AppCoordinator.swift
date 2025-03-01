//
// File name: AppCoordinator.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI


class AppCoordinator: ObservableObject {
    @Published var selectedCategory: SideMenuCategories = .main
    @Published var isSideMenuVisible: Bool = false
    
    func selectCategory(_ category: SideMenuCategories){
        if selectedCategory == category {
            isSideMenuVisible = false
        } else {
            selectedCategory = category
            isSideMenuVisible = false
        }
    }
}


