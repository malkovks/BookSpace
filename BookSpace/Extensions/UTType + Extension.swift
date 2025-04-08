//
// File name: UTType + Extension.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 08.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import UniformTypeIdentifiers

extension UTType {
    static var epub: UTType? {
        return UTType(filenameExtension: "epub", conformingTo: .zip)
    }
    
    static var docx: UTType? {
        return UTType(filenameExtension: "docx")
    }
}
