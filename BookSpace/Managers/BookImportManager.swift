//
// File name: BookImportManager.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 07.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import UniformTypeIdentifiers
import Foundation
import Compression
import ZIPFoundation




final class BookImportManager {
    static let shared = BookImportManager()
    
    private init() {}
    
    func importBook(from url: URL) throws -> ImportedBook {
        let fileExtension = url.pathExtension.lowercased()
        
        switch fileExtension {
        case "txt":
            return try importTxt(url: url)
        case "docx":
            return try importDocx(url: url)
        case "epub":
            return try importEpub(url: url)
        default:
            throw ImportError.unsupportedFormat
        }
    }
}

//MARK: - DOCX extension
private extension BookImportManager {
    
    func importDocx(url: URL) throws -> ImportedBook {
        let tempDir = try createTempDirectory()
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        
        try unzipFile(at: url, to: tempDir)
        let documentPath = tempDir.appendingPathComponent("word/document.xml")
        guard FileManager.default.fileExists(atPath: documentPath.path) else {
            throw ImportError.invalidDocumentStructure
        }
        
        let documentData = try Data(contentsOf: documentPath)
        let content = try parseDocxContent(documentData)
        let title = url.deletingPathExtension().lastPathComponent
        let author = try extractDocxAuthor(tempDir: tempDir)
        return ImportedBook(title: title,author: author,content: content, coverImage: nil)
    }
    
    func createTempDirectory() throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        return tempDir
    }
    
    func unzipFile(at sourceURL: URL, to destinationURL: URL) throws {
        let fileManager = FileManager()
        guard fileManager.fileExists(atPath: sourceURL.path) else {
            throw ImportError.parsingError
        }
        
        if !fileManager.fileExists(atPath: destinationURL.path) {
            try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true)
        }
        
        
        guard let archive = Archive(url: sourceURL, accessMode: .read) else {
            throw ImportError.errorUnzip
        }
        
        for entry in archive {
            let entryPath = destinationURL.appendingPathComponent(entry.path)
            let parentDir = entryPath.deletingLastPathComponent()
            
            if !fileManager.fileExists(atPath: parentDir.path) {
                try fileManager.createDirectory(at: parentDir, withIntermediateDirectories: true)
            }
            
            try archive.extract(entry, to: entryPath)
        }
    }
    
    func unzipShellZip(at source: URL, to destination: URL) -> Bool {
        return false
    }
    
    func parseDocxContent(_ data: Data) throws -> String {
        guard let xmlString = String(data: data, encoding: .utf8) else {
            throw ImportError.parsingError
        }
        
        var text = xmlString
            .replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ",options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let patterns = [
            "xmlns:[^=]+=\"[^\"]+\"",
            "w:[^=]+=\"[^\"]+\"",
            "&#[0-9]+;"
        ]
        
        for pattern in patterns {
            text = text.replacingOccurrences(of: pattern, with: "",options: .regularExpression)
        }
        return text
    }
    
    func extractDocxAuthor(tempDir: URL) throws -> String? {
        let corePath = tempDir.appendingPathComponent("docProps/core.xml")
        guard FileManager.default.fileExists(atPath: corePath.path) else { return nil }
        let coreData = try Data(contentsOf: corePath)
        let coreString = String(data: coreData,encoding: .utf8) ?? ""
        if let creatorRange = coreString.range(of: "<dc:creator>") {
            let substring = coreString[creatorRange.upperBound...]
            if let endRange = substring.range(of: "</dc:creator>") {
                return String(substring[..<endRange.lowerBound])
            }
        }
        return nil
    }
}

//MARK: - EPUB extension
private extension BookImportManager {
    func importEpub(url: URL) throws -> ImportedBook {
        let tempDir = try createTempDirectory()
        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }
        try unzipFile(at: url, to: tempDir)
        let containerPath = tempDir.appendingPathComponent("META-INF/container.xml")
        guard FileManager.default.fileExists(atPath: containerPath.path) else {
            throw ImportError.invalidDocumentStructure
        }
        
        let containerData = try Data(contentsOf: containerPath)
        guard let rootFilePath = try findRootFilePath(in: containerData) else {
            throw ImportError.parsingError
        }
        
        let rootFileURL = tempDir.appendingPathComponent(rootFilePath)
        let rootFileDir = rootFileURL.deletingLastPathComponent()
        
        let rootFileData = try Data(contentsOf: rootFileURL)
        let (title,author) = try parseEPUBMetadata(from: rootFileData)
        let content = try parseEPUBContent(rootFileDir: rootFileDir, rootFileData: rootFileData)
        return ImportedBook(title: title,author: author, content: content)
    }
    
    func findRootFilePath(in containerData: Data) throws -> String? {
        guard let containerString = String(data: containerData, encoding: .utf8) else {
            throw ImportError.parsingError
        }
        
        if let startRange = containerString.range(of: "full-path=\""),
           let endRange = containerString.range(of: "\"",range: startRange.upperBound..<containerString.endIndex) {
            return String(containerString[startRange.upperBound..<endRange.lowerBound])
        }
        return nil
    }
    
    func parseEPUBMetadata(from opfData: Data) throws -> (title: String, author: String?){
        guard let opfString = String(data: opfData, encoding: .utf8) else {
            throw ImportError.parsingError
        }
        
        var title: String = "Unknown"
        var author: String? = nil
        
        if let titleRange = opfString.range(of: "<dc:title>"),
           let titleEndRange = opfString.range(of: "</dc:title>") {
            title = String(opfString[titleRange.upperBound..<titleEndRange.lowerBound])
        }
        if let authorRange = opfString.range(of: "<dc:creator>"),
           let authorEndRange = opfString.range(of: "</dc:creator>") {
            author = String(opfString[authorRange.upperBound..<authorEndRange.lowerBound])
        }
        
        return (title,author)
    }
    
    func parseEPUBContent(rootFileDir: URL, rootFileData: Data) throws -> String {
        guard let opfString = String(data: rootFileData, encoding: .utf8) else {
            throw ImportError.parsingError
        }
        
        var content = ""
        var manifestItem = [String: String]()
        
        if let manifestStart = opfString.range(of: "<manifest>"),
           let manifestEnd = opfString.range(of: "</manifest>") {
            let manifestContent = String(opfString[manifestStart.upperBound..<manifestEnd.lowerBound])
            
            let itemPattern = "<item[^>]+id=\"([^\"]+)\"[^>]+href=\"([^\"]+)\"[^>]*>"
            let regex = try NSRegularExpression(pattern: itemPattern, options: [])
            let matches = regex.matches(in: manifestContent, range: NSRange(manifestContent.startIndex..., in: manifestContent))
            
            for match in matches {
                if match.numberOfRanges >= 3,
                   let idRange = Range(match.range(at: 1), in: manifestContent),
                   let hrefRange = Range(match.range(at: 2),in: manifestContent) {
                    let id = String(manifestContent[idRange])
                    let href = String(manifestContent[hrefRange])
                    manifestItem[id] = href
                }
            }
        }
        
        if let spineStart = opfString.range(of: "<spine[^>]*>"),
           let spineEnd = opfString.range(of: "</spine>") {
            let spineContent = String(opfString[spineStart.upperBound..<spineEnd.lowerBound])
            let itemRefPattern = "<itemref[^>]+idref=\"([^\"]+)\"[^>]*/>"
            let regex = try NSRegularExpression(pattern: itemRefPattern, options: [])
            let matches = regex.matches(in: spineContent, range: NSRange(spineContent.startIndex...,in: spineContent))
            for match in matches {
                if match.numberOfRanges >= 2,
                   let idRefRange = Range(match.range(at: 1), in: spineContent) {
                    let idRef = String(spineContent[idRefRange])
                    
                    if let href = manifestItem[idRef] {
                        let contentPath = rootFileDir.appendingPathComponent(href)
                        if let htmlContent = try? String(contentsOf: contentPath, encoding: .utf8) {
                            let text = htmlContent
                                .replacingOccurrences(of: "<[^>]+>", with: " ",options: .regularExpression)
                                .replacingOccurrences(of: "\\s+", with: " " ,options: .regularExpression)
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                            content += text + "\n\n"
                        }
                    }
                }
            }
        }
        
        guard !content.isEmpty else {
            throw ImportError.parsingError
        }
        
        return content
    }
}

//MARK: - TXT extension
private extension BookImportManager {
    
    func importTxt(url: URL) throws -> ImportedBook {
        let content = try String(contentsOf: url, encoding: .utf8)
        let author = extractAuthorFromText(content)
        return ImportedBook(
            title: url.deletingPathExtension().lastPathComponent,
            author: author,
            content: content)
    }
    
    func extractAuthorFromText(_ text: String) -> String? {
        let lines = text.components(separatedBy: .newlines).prefix(10)
        for line in lines {
            if line.lowercased().contains("author:") {
                return line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }
}
