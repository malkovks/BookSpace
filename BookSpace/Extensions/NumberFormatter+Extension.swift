//
// File name: NumberFormatter+Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 29.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

extension NumberFormatter {
    static var rgbFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimum = 0
        formatter.maximum = 1
        return formatter
    }
}
