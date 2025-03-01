//
// File name: BookSortOption.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import Foundation


enum BookSortOption {
    case newest
    case classic
    
    var urlValue: String {
        switch self {
        case .newest:
            return "newest"
        case .classic:
            return "relevance"
        }
    }
}
