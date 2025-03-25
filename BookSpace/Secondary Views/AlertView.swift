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
    var confirmAction: (() -> Void)
    var cancelAction: (() -> Void)
}

struct AlertView: View {
        
    @Binding var isPresented: Bool
    let model: AlertModel

    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Color.skyBlue
                .ignoresSafeArea()
            Color.clear
                .background(.thickMaterial)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 0.5), value: isPresented)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                    model.cancelAction()
                }
            
            if isPresented {
                VStack {
                    Spacer()
                    containerView
                    buttonContainerView
                        .padding(.top, 24)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                .transition(.slide.animation(.easeInOut(duration: 0.5)))
            }
            if isPresented {
                closeButton
                    .transition(.slide.animation(.easeInOut(duration: 0.5)))
                    .padding()
            }
            
            
        }
        .onTapGesture {
            model.cancelAction()
        }
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                withAnimation {
                    isPresented = false
                    model.cancelAction()
                }
            } label: {
                Circle()
                    .foregroundStyle(.paperYellow)
                    .frame(width: 40, height: 40, alignment: .center)
                    .overlay {
                        createImage("xmark")
                    }
                
            }
        }
        .padding([.top,.trailing],30)
        .shadow(radius: 2,x: 1,y: 2)
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
                    isPresented = false
                    model.confirmAction()
                }
            } label: {
                HStack(alignment: .center) {
                    createImage("trash.square",primaryColor: .skyBlue,secondaryColor: .white)
                    Text(model.confirmActionText)
                        .foregroundStyle(.skyBlue)
                    Spacer()
                }
                .padding()
                .background(Color.alertRed)
                .clipShape(.rect(cornerRadius: 24,style: .circular))
                .shadow(radius: 2,x: 1,y: 2)
            }
            
            Button {
                withAnimation {
                    isPresented = false
                    model.cancelAction()
                }
                
            } label: {
                HStack(alignment: .center) {
                    createImage("xmark.diamond.fill",primaryColor: .blue,secondaryColor: .white)
                    Text(model.cancelActionText)
                    Spacer()
                }
                .padding()
                .background(Color.paperYellow)
                .clipShape(.rect(cornerRadius: 24,style: .circular))
                .shadow(radius: 2,x: 1,y: 2)
            }
        }
    }
}

#Preview {
    let mockModel = AlertModel(title: "Warning", message: "Some message for you", confirmActionText: "Delete", cancelActionText: "Cancel") {
        
    } cancelAction: {
        
    }

    AlertView(isPresented: .constant(true), model: mockModel)
}
