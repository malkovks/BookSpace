//
// File name: FilterCategories.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 01.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

enum FilterCategories: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case partial
    case full
    case free
    case paid
    case ebooks //default
    
    var urlValue: String {
        switch self {
        case .partial:
            return "partial"
        case .full:
            return "full"
        case .free:
            return "free-ebooks"
        case .paid:
            return "paid-ebooks"
        case .ebooks:
            return "ebooks"
        }
    }
    
    var title: String {
        switch self {
        case .partial:
            return "Partial"
        case .full:
            return "Full preview"
        case .free:
            return "Free e-books"
        case .paid:
            return "Paid e-books"
        case .ebooks:
            return "All e-books"
        }
    }
    
}
