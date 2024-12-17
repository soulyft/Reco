//
//  MainViewModel.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI
import SwiftData
import Observation

@Observable
@MainActor
class MainViewModel {
    var userQuery: String = ""
    var currentRecommendation: Recommendation?
    var isLoading = false
    var errorMessage: String?
    var selectedTab: Int = 1
    
    var context: ModelContext
    private let apiClient = APIClient()
    
    init(context: ModelContext) {
        self.context = context
        ensureUserProfileExists()
    }
    
    private func ensureUserProfileExists() {
        do {
            let profiles = try context.fetch(FetchDescriptor<UserProfile>())
            if profiles.isEmpty {
                let profile = UserProfile()
                context.insert(profile)
                try context.save()
            }
        } catch {
            print("Error ensuring user profile exists: \(error)")
        }
    }

    private var userProfile: UserProfile? {
        do {
            return try context.fetch(FetchDescriptor<UserProfile>()).first
        } catch {
            print("Error fetching user profile: \(error)")
            return nil
        }
    }
    
    // Fetch new recommendation
    func getRecommendation() {
        Task {
            guard !userQuery.isEmpty else {
                print("User query is empty.")
                return
            }
            
            isLoading = true
            errorMessage = nil
            
            do {
                guard let profile = userProfile else {
                    errorMessage = "User profile not found."
                    print("Error: User profile not found.")
                    return
                }
                
                let product = try await apiClient.fetchRecommendation(for: userQuery, userProfile: profile)
                print("API returned product: \(product)")
                
                // Save recommendation
                let reco = Recommendation(name: product.name,
                                          price: product.price,
                                          summary: product.summary,
                                          imageURL: product.imageURL,
                                          affiliateLink: product.affiliateLink)
                context.insert(reco)
                try context.save()
                
                currentRecommendation = reco
                print("Recommendation saved and updated.")
            } catch {
                errorMessage = "Failed to get recommendation: \(error.localizedDescription)"
                print("Error during API call: \(error.localizedDescription)")
            }
            userQuery = ""
            isLoading = false
        }
    }

    // Refine current recommendation
    func iterateRecommendation() {
        Task {
            guard let currentReco = currentRecommendation else {
                errorMessage = "No recommendation to iterate on."
                return
            }
            
            isLoading = true
            errorMessage = nil
            
            do {
                guard let profile = userProfile else {
                    errorMessage = "User profile not found."
                    return
                }
                
                let newQuery = "return a new product \(userQuery) refined from \(currentReco.name) at \(currentReco.price): \(currentReco.summary)"
                print("Iterating with query: \(newQuery)")
                
                let product = try await apiClient.fetchRecommendation(for: newQuery, userProfile: profile)
                print("API returned updated product: \(product)")
                
                let reco = Recommendation(name: product.name,
                                          price: product.price,
                                          summary: product.summary,
                                          imageURL: product.imageURL,
                                          affiliateLink: product.affiliateLink)
                
                context.insert(reco)
                try context.save()
                currentRecommendation = reco
                print("Recommendation updated with new iteration.")
            } catch {
                errorMessage = "Failed to iterate recommendation: \(error.localizedDescription)"
                print("Error during iteration: \(error.localizedDescription)")
            }
            userQuery = ""
            isLoading = false
        }
    }

    // Clear recommendation
    func clearRecommendation() {
        currentRecommendation = nil
        userQuery = ""
        print("Recommendation cleared.")
    }
}
