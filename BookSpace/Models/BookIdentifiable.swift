//
// File name: BookIdentifiable.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 02.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import Foundation

struct BookIdentifiable: Hashable {
    
    let book: Book
    func hash(into hasher: inout Hasher) {
        hasher.combine(book.id)
    }
    
    static func == (lhs: BookIdentifiable, rhs: BookIdentifiable) -> Bool {
        lhs.book.id == rhs.book.id
    }
}
