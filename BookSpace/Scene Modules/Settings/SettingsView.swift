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
    @Environment(\.colorScheme) var colorScheme
    @State private var isColorPickerPresented: Bool = false
    @State private var showCameraAlert : Bool = false
    @State private var showInfoView: Bool = false
    
    var updateRightButtons: (_ buttons: AnyView) -> Void
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                settings.backgroundColor
                    .ignoresSafeArea()
                formView
                    .padding(.top, 90)
            }
            .onAppear {
                updateRightButtons(AnyView(
                    Button(action: {
                        showInfoView.toggle()
                    }, label: {
                        createImage("questionmark.circle")
                    })
                ))
            }
            .fullScreenCover(isPresented: $isColorPickerPresented) {
                CustomColorPickerView(color: $settings.backgroundColor, goBack: {
                    isColorPickerPresented.toggle()
                })
                .preferredColorScheme(.light)
                
            }
            
            .sheet(isPresented: $showInfoView, content: {
                SettingsInfoView()
            })
            
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
                HStack(spacing: 16) {
                    Button {
                        settings.isTextBold.toggle()
                    } label: {
                        Text("B")
                            
                            .font(.system(size: 18,weight: .bold))
                            .foregroundStyle(settings.isTextBold ? .primary : .secondary)
                            .padding(.vertical,8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(settings.isTextBold ? .skyBlue : .clear)
                                    .stroke(.blackText, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .animation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.3), value: settings.isTextBold)

                    Button {
                        settings.isTextItalic.toggle()
                    } label: {
                        Text("I")
                            .italic()
                            .font(.system(size: 18))
                            .padding(.vertical,8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(settings.isTextItalic ? .skyBlue : .clear)
                                    .stroke(.blackText, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .animation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.3), value: settings.isTextItalic)
                    
                    Button {
                        settings.isTextUnderlined.toggle()
                    } label: {
                        Text("U")
                            .underline()
                            .font(.system(size: 18))
                            .padding(.vertical,8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(settings.isTextUnderlined ? .skyBlue : .clear)
                                    .stroke(.blackText, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .animation(.spring(duration: 0.4, bounce: 0.2, blendDuration: 0.3), value: settings.isTextUnderlined)
                }
                .frame(maxWidth: .infinity)
                
            } header: {
                Text("Text style")
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
                .foregroundStyle(.blackText)
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
                            } else {
                                settings.isCameraAccessAllowed = true
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
                    actionTextView("Clean cache")
                }
                
                Button {
                    print("Clean data")
                } label: {
                    actionTextView("Clean Data")
                }
                
                
            } header: {
                Text("Clean cache and data")
            }
        }
        .scrollContentBackground(.hidden)
    }

    private func actionTextView(_ text: String) -> some View {
        return HStack {
            Spacer()
            Text(text)
                .foregroundStyle(.updateBlue)
            Spacer()
        }
    }
    
    
}
