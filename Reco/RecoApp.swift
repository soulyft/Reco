//
//  RecoApp.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI
import SwiftData

@main
struct MyRecoAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [UserProfile.self, Recommendation.self])
        
    }
    
}
