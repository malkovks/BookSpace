//
// File name: Date+ Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import Foundation

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}
