//
// File name: View+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 06.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

extension View {
    func messageBook(_ book: Book) -> String {
        let title = book.volumeInfo.title
        let author = book.volumeInfo.authors.joined(separator: ", ")
        let link = book.volumeInfo.canonicalVolumeLink
        return "Check out this book \"\(title)\" by \(author). You can read it here: \(link)"
    }
    
    @ViewBuilder
    func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}


