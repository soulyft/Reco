//
//  ContentView.swift
//  Reco
//
//  Created by Corey Lofthus on 12/16/24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) var context
  
    @State private var viewModel: MainViewModel
    
    init() {
            // Use a placeholder value; actual context will be injected in `onAppear`
            _viewModel = State(initialValue: MainViewModel(context: ModelContext.previewContext))
        }
    

        
    var body: some View {
          TabView(selection: $viewModel.selectedTab) {
              UserProfileView()
                  .tabItem {
                      Label("Profile", systemImage: "person.crop.circle")
                  }
                  .tag(0) // Tag for identifying this tab
              
                  RecoView(viewModel: viewModel)
                      .tabItem {
                          Label("Home", systemImage: "house")
                      }
                      .tag(1) // Tag for identifying this tab
              
              HistoryView()
                  .tabItem {
                      Label("History", systemImage: "clock")
                  }
                  .tag(2) // Tag for identifying this tab
          }
          .onAppear {
              // Update the context on viewModel once environment is available
              if viewModel.context !== context {
                  viewModel.context = context
              }
          }
          .environment(viewModel)
      }

  }

extension ModelContext {
    static var previewContext: ModelContext {
        let container = try! ModelContainer(for: UserProfile.self, Recommendation.self)
        return ModelContext(container)
    }
}
#Preview {
    ContentView()
        .modelContainer(for: [UserProfile.self, Recommendation.self])
}
