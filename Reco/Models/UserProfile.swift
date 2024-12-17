//
//  UserProfile.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI
import SwiftData

@Model
class UserProfile {
    @Attribute(.unique) var id: UUID = UUID() // Ensures uniqueness
    var name: String = "User"
    var budgetSensitivity: Double = 0.5
    var brandLoyalty: Double = 0.5

    init(name: String = "User", budgetSensitivity: Double = 0.5, brandLoyalty: Double = 0.5) {
        self.name = name
        self.budgetSensitivity = budgetSensitivity
        self.brandLoyalty = brandLoyalty
    }
}
