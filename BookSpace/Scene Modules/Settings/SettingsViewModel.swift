//
// File name: SettingsViewModel.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 14.04.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI
import SwiftData

@Observable
class SettingsViewModel: ObservableObject {
    
    let modelContext: ModelContext
    let filesManager: FilesDataManager
    let dataManager: BooksDataManager
    
    var isLoading: Bool = false
    
    var selectedFont: String = "System" {
        didSet { updateIfneeded(oldValue, selectedFont, key: SettingsKeys.selectedFont) }
    }
    var headerFontSize: CGFloat = 24 {
        didSet { updateIfneeded(oldValue , headerFontSize, key: SettingsKeys.headerFontSize)}
    }
    
    var backgroundColor: Color = .secondary {
        didSet {
            let hexColor = backgroundColor.hexString()
            updateIfneeded(oldValue.hexString(), hexColor, key: SettingsKeys.backgroundColor)
        }
    }
    var isCameraAccessAllowed: Bool = true {
        didSet { updateIfneeded(oldValue, isCameraAccessAllowed, key: SettingsKeys.isCameraAccessAllowed) }
    }
    var appearanceMode: AppearanceMode = {
        let raw = UserDefaults.standard.string(forKey: SettingsKeys.appearanceMode)
                  ?? AppearanceMode.automatic.rawValue
        return AppearanceMode(rawValue: raw) ?? .automatic
    }() {
        didSet {
            UserDefaults.standard.set(appearanceMode.rawValue,
                                      forKey: SettingsKeys.appearanceMode)
        }
    }
    
    var isTextBold: Bool = false {
        didSet {
            updateIfneeded(oldValue, isTextBold, key: SettingsKeys.boldFont)
        }
    }
    
    var isTextItalic: Bool = false {
        didSet {
            updateIfneeded(oldValue, isTextItalic, key: SettingsKeys.italicFont)
        }
    }
    
    var isTextUnderlined: Bool = false {
        didSet {
            updateIfneeded(oldValue, isTextUnderlined, key: SettingsKeys.underlineFont)
        }
    }
    
    enum AppearanceMode: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case light, dark, automatic
    }
    
    private enum SettingsKeys {
        static let selectedFont = "selectedFont"
        static let headerFontSize = "headerFontSize"
        static let backgroundColor = "backgroundColor"
        static let isCameraAccessAllowed = "isCameraAccessAllowed"
        static let appearanceMode = "appearanceMode"
        static let boldFont = "boldFont"
        static let italicFont = "italicFont"
        static let underlineFont = "underlineFont"
    }
    
    init(modelContext: ModelContext){
        self.modelContext = modelContext
        selectedFont = UserDefaults.standard.string(forKey: SettingsKeys.selectedFont) ?? "System"
        headerFontSize = CGFloat(UserDefaults.standard.double(forKey: SettingsKeys.headerFontSize))
        backgroundColor = Color(hex: UserDefaults.standard.string(forKey: SettingsKeys.backgroundColor) ?? Color.skyBlue.hexString())
        isCameraAccessAllowed = UserDefaults.standard.bool(forKey: SettingsKeys.isCameraAccessAllowed)
        appearanceMode = AppearanceMode(rawValue: UserDefaults.standard.string(forKey: SettingsKeys.appearanceMode) ?? AppearanceMode.automatic.rawValue) ?? .automatic
        isTextBold = UserDefaults.standard.bool(forKey: SettingsKeys.boldFont)
        isTextItalic = UserDefaults.standard.bool(forKey: SettingsKeys.italicFont)
        isTextUnderlined = UserDefaults.standard.bool(forKey: SettingsKeys.underlineFont)
        self.filesManager = FilesDataManager(context: modelContext)
        self.dataManager = BooksDataManager(context: modelContext)
    }
    
    func cleanCache(){
        isLoading = true
        Task {
            do {
                
            } catch {
                
            }
        }
    }
    
    func deleteAllData(){
        isLoading = true
        Task {
            do {
                async let deleteBooks: () = try dataManager.deleteAllLoadedBooks()
                async let deleteFiles: () = try filesManager.deleteAllPDFFiles()
                _ = try await [deleteBooks, deleteFiles]
            } catch {
                print("Error deleting files from storages: \(error.localizedDescription)")
            }
            await MainActor.run { isLoading = false }
        }
    }
    
    @MainActor
    func toggleCameraAccess(completion: @escaping (_ showSettingAlert: Bool) -> Void ){
        Task {
            await CameraAccessManager.shared.requestAccess { [weak self] result in
                switch result {
                case .success(let success):
                    if success {
                        self?.isCameraAccessAllowed = true
                    } else {
                        self?.isCameraAccessAllowed = false
                        completion(true)
                    }
                case .failure:
                    self?.isCameraAccessAllowed = false
                    completion(true)
                }
            }
        }
    }
    
    private func updateIfneeded<T: Equatable>(_ old: T, _ new: T, key: String) {
        if old != new {
            UserDefaults.standard.set(new, forKey: key)
        }
    }
}
