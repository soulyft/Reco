//
//  UserProfileView.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI
import SwiftData

struct UserProfileView: View {
    @Query private var userProfile: [UserProfile]
    @Environment(\.modelContext) private var context

    @State private var editedName: String = ""

    var body: some View {
        let profile = userProfile.first ?? createAndSaveDefaultProfile()

        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $editedName, onCommit: {
                    profile.name = editedName
                    saveProfile()
                })
                .onAppear {
                    editedName = profile.name
                }
                .font(.headline)
            }

            Section(header: Text("Preferences")) {
                ForEach(UserFactor.allCases, id: \.self) { factor in
                    FactorSliderView(
                        title: factor.rawValue,
                        value: getBinding(for: factor, profile: profile)
                    )
                }
            }
        }
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Methods
    
    private func createAndSaveDefaultProfile() -> UserProfile {
        let newProfile = UserProfile()
        context.insert(newProfile)
        saveProfile()
        return newProfile
    }

    private func saveProfile() {
        do {
            try context.save()
        } catch {
            print("Failed to save profile: \(error.localizedDescription)")
        }
    }

    private func getBinding(for factor: UserFactor, profile: UserProfile) -> Binding<Double> {
        switch factor {
        case .budgetSensitivity:
            return Binding(
                get: { profile.budgetSensitivity },
                set: { newValue in
                    profile.budgetSensitivity = newValue
                    saveProfile()
                }
            )
        case .brandLoyalty:
            return Binding(
                get: { profile.brandLoyalty },
                set: { newValue in
                    profile.brandLoyalty = newValue
                    saveProfile()
                }
            )
        }
    }
}

// MARK: - Subviews

struct FactorSliderView: View {
    let title: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(Int(value * 100))%")
            Slider(value: $value, in: 0...1, step: 0.01)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Enums

enum UserFactor: String, CaseIterable {
    case budgetSensitivity = "Budget Sensitivity"
    case brandLoyalty = "Brand Loyalty"
}
