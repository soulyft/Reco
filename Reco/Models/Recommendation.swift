//
//  Recommendation.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI
import SwiftData

@Model
class Recommendation {
    var id: UUID
    var name: String
    var price: Double
    var summary: String
    var imageURL: String
    var affiliateLink: String
    var date: Date
    
    init(id: UUID = UUID(), name: String, price: Double, summary: String, imageURL: String, affiliateLink: String, date: Date = Date()) {
        self.id = id
        self.name = name
        self.price = price
        self.summary = summary
        self.imageURL = imageURL
        self.affiliateLink = affiliateLink
        self.date = date
    }
}
