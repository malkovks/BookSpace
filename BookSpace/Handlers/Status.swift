//
// File name: Status.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 15.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

enum Status {
    case success
    case error
    case warning
    case update
    
    var title: String {
        switch self {
        case .success:
            return "Successfuly"
        case .error:
            return "Failure"
        case .warning:
            return "Warning"
        case .update:
            return "Updated"
        }
    }
    
    var image: String {
        switch self {
        case .success:
            return "checkmark.diamond"
        case .error:
            return "xmark.diamond"
        case .warning:
            return "exclamationmark.triangle"
        case .update:
            return "arrow.trianglehead.2.counterclockwise"
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .alertRed
        case .warning:
            return .warningYellow
        case .update:
            return .updateBlue
        }
    }
}

enum ValueType {
    case favorite
    case planned
}
