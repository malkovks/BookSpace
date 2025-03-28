//
// File name: AlertView.swift
// Package: BookSpace
//
// Created by Malkov Konstantin on 25.03.2025.
// Copyright (c) 2024 Malkov Konstantin . All rights reserved.

import SwiftUI

struct AlertModel {
    var title: String = "Warning"
    let message: String
    let confirmActionText: String
    let cancelActionText: String
    var hideButton = false
    var confirmAction: (() -> Void)
    var cancelAction: (() -> Void)
}

struct AlertView: View {
    
    @Binding var isShowingAlert: Bool
    let model: AlertModel
    @State private var isPresented: Bool = false
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            BlurView(style: .systemThickMaterialDark)
                .opacity(0.9)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isShowingAlert = false
                    }
                }
            if isShowingAlert {
                VStack {
                    Spacer()
                    containerView
                    buttonContainerView
                        .padding(.top, 24)
                        .padding(.horizontal, 10)
                        .opacity(model.hideButton ? 0 : 1)
                    Spacer()
                }
                .padding()
                CircleCloseButton(cancelAction: model.cancelAction)
                    .padding()
            }
        }
        .animation(.default, value: isPresented)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isPresented = true
            }
        }
        .onDisappear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isPresented = false
            }
        }
        .animation(.interactiveSpring(duration: 1), value: isShowingAlert)
        
    }
    
    private var titleView: some View {
        HStack {
            Text(model.title)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
        }
    }
    
    private var containerView: some View {
        VStack {
            LinearGradient(colors: [.pink,.blue], startPoint: .top, endPoint: .bottom)
                .mask(titleView)
                .frame(height: 35)
            Text(model.message)
                .font(.system(size: 24,weight: .medium  ,design: .rounded))
                .foregroundStyle(.alertRed)
                .textScale(.secondary)
        }
        .padding()
        .background(Color.paperYellow)
        .clipShape(.rect(cornerRadius: 24))
        .shadow(radius: 2,x: 1,y: 2)
    }
    
    private var buttonContainerView: some View {
        HStack(spacing: 24) {
            Button {
                withAnimation {
                    model.confirmAction()
                }
            } label: {
                HStack(alignment: .center,spacing: 10) {
                    createImage("trash.square",primaryColor: .skyBlue,secondaryColor: .white)
                    Text(model.confirmActionText)
                        .foregroundStyle(.skyBlue)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.alertRed)
                .clipShape(.rect(cornerRadius: 24,style: .circular))
                .shadow(radius: 2,x: 1,y: 2)
            }
            
            Button {
                withAnimation {
                    model.cancelAction()
                }
                
            } label: {
                HStack(alignment: .center) {
                    createImage("xmark.diamond.fill",primaryColor: .blue,secondaryColor: .white)
                    Text(model.cancelActionText)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.paperYellow)
                .clipShape(.rect(cornerRadius: 24,style: .circular))
                .shadow(radius: 2,x: 1,y: 2)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let mockModel = AlertModel(title: "Warning", message: "Some message for you", confirmActionText: "Delete", cancelActionText: "Cancel") {
        
    } cancelAction: {
        
    }

    AlertView( isShowingAlert: .constant(true), model: mockModel)
}
