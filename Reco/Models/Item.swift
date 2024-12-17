//
//  Item.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
