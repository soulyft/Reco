//
//  ProductCard.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI

struct ProductCard: View {
    let recommendation: Recommendation
    @Binding var isCompact: Bool 
    
    var body: some View {
        VStack {
          
            if isCompact {
                // Compact Layout: Image on the left
                HStack(alignment: .top, spacing: 12) {
                    productImage
                    productDetails
                    Spacer()
                }
                .padding(16)
                
            } else {
                // Full-size Layout: Image on top
                VStack(alignment: .center, spacing: 12) {
                    productImage
                    productDetails
                }
                .padding(20)
            }
            
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    // MARK: - Product Image
    @State private var showProgressView: Bool = true
    @State private var cachedImage: Image? = nil

    private var productImage: some View {
        AsyncImage(url: URL(string: recommendation.imageURL)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    if showProgressView {
                        ProgressView() // Show progress view initially
                            .transition(.opacity)
                            .frame(height: isCompact ? 80 : 180)
                    } else {
                        Image(systemName: "photo.artframe") // Default fallback icon
                            .resizable()
                            .scaledToFit()
                            .frame(height: isCompact ? 80 : 180)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
                .onAppear {
                    // Turn off the progress view after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showProgressView = false
                        }
                    }
                }
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: isCompact ? 80 : 180)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: isCompact ? 1 : 2)
                    .onAppear {
                        cachedImage = image // Cache SwiftUI Image directly
                    }
            
            case .failure:
                Image(systemName: "photo.artframe")
                    .resizable()
                    .scaledToFit()
                    .frame(height: isCompact ? 80 : 180)
                    .foregroundColor(.gray.opacity(0.5))
                
            @unknown default:
                EmptyView()
            }
        }
    }
    
    // MARK: - Product Details
    private var productDetails: some View {
        VStack(alignment: .leading, spacing: isCompact ? 4 : 8) {
            Text(recommendation.name)
                .font(isCompact ? .headline : .title2)
                .fontWeight(.bold)
                .lineLimit(2)
            
            Text("$\(recommendation.price, specifier: "%.2f")")
                .font(isCompact ? .headline : .title3)
                .fontDesign(.monospaced)
                .fontWeight(.semibold)
                .foregroundColor(.green)
            
            if !isCompact {
                Text(recommendation.summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                Link(destination: URL(string: recommendation.affiliateLink) ?? URL(string: "https://amazon.com")!) {
                    Text("Buy Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.top)
                }
            }

            
        }
    }
}
