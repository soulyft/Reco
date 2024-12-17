//
//  RecoView.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI
import SwiftData

struct RecoView: View {
    @Bindable var viewModel: MainViewModel
    @FocusState private var isTextFieldFocused: Bool // Track focus state
    @State var isCompact: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State var isCardSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // Display recommendation if available
            if let reco = viewModel.currentRecommendation {
                ProductCard(recommendation: reco,
                            isCompact: $isCompact)
                    .padding()
                    .onTapGesture {
                        if !isCompact {
                            isCardSheetPresented = true
                        }
                    }
                    .sheet(isPresented: $isCardSheetPresented) {
                        VStack{
                            ProductCard(recommendation: reco,
                                        isCompact: $isCompact)
                            Spacer()
                            Text("user reviews and more information")
                            Spacer()
                        }
                    }
            }
            
            // Show loading spinner
            if viewModel.isLoading {
                ProgressView("Loading reco...")
            }
            
            Spacer()
            
            // Input text field
            TextField("What are you looking for?", text: $viewModel.userQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .focused($isTextFieldFocused) // Track focus state
            
            // Buttons for updating and clearing
            HStack {
                if viewModel.currentRecommendation != nil {
                    Button(action: {
                        viewModel.iterateRecommendation()
                        isTextFieldFocused = false // Dismiss keyboard
                    }) {
                        Text("Update Reco")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        viewModel.clearRecommendation()
                        viewModel.userQuery = "" // Clear text input
                        isTextFieldFocused = false // Dismiss keyboard
                        
                    }) {
                        Text("Clear Reco")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else if !viewModel.isLoading {
                    Button(action: {
                        viewModel.getRecommendation()
                        isTextFieldFocused = false // Dismiss keyboard
                    }) {
                        Text("Get Reco")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            // Show error message if any
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
        }
        .background(content: {
            meshGradientBackground // Gradient background
                .colorInvertIfDarkMode(colorScheme: colorScheme)
        })
        .onTapGesture {
            isTextFieldFocused = false // Dismiss keyboard
        }
        .onChange(of: isTextFieldFocused) { oldValue, newValue in
            withAnimation(.bouncy) {
                isCompact = isTextFieldFocused
            }
          
        }
    }
    
    // MARK: - Mesh Gradient Background
    private var meshGradientBackground: some View {
        Rectangle()
            .fill(
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: [
                        SIMD2<Float>(0, 0), SIMD2<Float>(0.5, 0), SIMD2<Float>(1, 0),
                        SIMD2<Float>(0, 0.5), SIMD2<Float>(0.5, 0.5), SIMD2<Float>(1, 0.5),
                        SIMD2<Float>(0, 1), SIMD2<Float>(0.5, 1), SIMD2<Float>(1, 1)
                    ],
                    colors: [
                        Color(red: 1, green: 0.85, blue: 0.7), // Soft warm color
                        Color(red: 0.95, green: 0.95, blue: 1), // Neutral
                        Color(red: 0.7, green: 0.85, blue: 1), // Soft cool color
                        Color(red: 0.9, green: 0.75, blue: 1), // Subtle purple
                        Color.white,
                        Color(red: 0.8, green: 1, blue: 0.85), // Subtle green
                        Color.white,
                        Color(red: 1, green: 0.9, blue: 0.8),
                        Color(red: 0.75, green: 0.85, blue: 1)
                    ],
                    background: Color.white, // Fallback
                    smoothsColors: true
                )
            )
            .ignoresSafeArea()
    }
}

extension View {
    func colorInvertIfDarkMode(colorScheme: ColorScheme) -> some View {
        self.modifier(ColorInvertModifier(shouldInvert: colorScheme == .dark))
    }
}

struct ColorInvertModifier: ViewModifier {
    let shouldInvert: Bool
    
    func body(content: Content) -> some View {
        if shouldInvert {
            content
                .colorInvert() // Apply color inversion
        } else {
            content
        }
    }
}
