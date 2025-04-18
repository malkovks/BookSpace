//
// File name: SettingsView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 26.02.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel
    @Environment(\.openURL) var openURL
    @State private var isColorPickerPresented: Bool = false
    @State private var showCameraAlert : Bool = false
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                Color.colorBackground
                    .ignoresSafeArea()
                formView
                    .padding(.top, 90)
            }
            .onAppear {
                updateRightButtons(AnyView(
                    Text("No buttons")
                ))
            }
            .fullScreenCover(isPresented: $isColorPickerPresented) {
                CustomColorPickerView(color: $settings.backgroundColor, goBack: {
                    isColorPickerPresented.toggle()
                })
            }
            .alert("Camera Access", isPresented: $showCameraAlert) {
                Button("Go to settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("To change camera access, please go to Settings -> Privacy -> Camera. ")
            }
            .onAppear {
                settings.toggleCameraAccess { _ in }
            }
            
        }
    }
    
    private var formView: some View {
        
        Form {
            Section {
                Picker("Select font", selection: $settings.selectedFont) {
                    ForEach(UIFont.familyNames,id: \.self) { fontName in
                        Text(fontName)
                            .font(.custom(fontName, size: 20))
                    }
                    
                }
                .pickerStyle(.wheel)
            } header: {
                Text("Font")
            }
            
            Section {
                VStack {
                    Text("Font size example")
                        .font(.custom(settings.selectedFont, size: settings.headerFontSize))
                    Slider(value: $settings.headerFontSize, in: 14...30, step: 1)
                        .tint(.skyBlue)
                }
            } header: {
                Text("Header font size")
            }
            .listRowSeparator(.hidden)
            
            Section {
                Button {
                    isColorPickerPresented.toggle()
                } label: {
                    HStack {
                        Text("Open Color picker")
                        Spacer()
                        Circle()
                            .foregroundStyle(settings.backgroundColor)
                            .frame(width: 30, height: 30)
                            .overlay {
                                Circle()
                                    .stroke(Color.black, lineWidth: 1)
                            }
                    }
                }
                .foregroundStyle(.black)
            } header: {
                Text("Background Color")
            }
            
            Section {
                Toggle("Camera access", isOn: Binding(get: {
                    settings.isCameraAccessAllowed
                }, set: { newValue in
                    if newValue {
                        settings.toggleCameraAccess { showSettingAlert in
                            if showSettingAlert {
                                showCameraAlert = true
                            }
                        }
                    } else {
                        showCameraAlert = true
                    }
                }) )
                .tint(.skyBlue)
            } header: {
                Text("Access to camera")
            }
            
            Section {
                Picker("Mode", selection: $settings.appearanceMode) {
                    ForEach(SettingsViewModel.AppearanceMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Application theme")
            }
            
            Section {
                Button {
                    print("Clean cache")
                } label: {
                    Text("Clean Cache")
                }
                
                Button {
                    print("Clean data")
                } label: {
                    Text("Clean data")
                }
                
                
            } header: {
                Text("Clean cache and data")
            }
        }
        .scrollContentBackground(.hidden)
    }

    
    
}

#Preview {
    let settings = SettingsViewModel()
        
        return SettingsView { buttons in
            
        }
        .environmentObject(settings)

}
