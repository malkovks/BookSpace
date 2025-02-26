//
// File name: BookCollectionViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

final class BookCollectionViewModel: ObservableObject {
    var isSearchFieldVisible = false
    var searchText: String = ""
    
    var isSideMenuVisible: Bool = false
    var selectedCategory: SideMenuCategories = .main
}

