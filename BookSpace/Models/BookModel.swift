//
// File name: BookModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 28.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct BookModel {
    let id: UUID = UUID()
    let image: Image = .init(systemName: "info.circle")
    let title: String = "Example"
}
