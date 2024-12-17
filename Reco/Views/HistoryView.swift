import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Recommendation.date, order: .reverse) var recommendations: [Recommendation]
    @Environment(\.modelContext) private var modelContext
    @Environment(MainViewModel.self) var viewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recommendations) { reco in
                    VStack(alignment: .leading) {
                        Text(reco.name)
                            .font(.headline)
                        Text("$\(reco.price, specifier: "%.2f") - \(reco.summary)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        handleRecommendationTap(recommendation: reco)
                    }
                }
                .onDelete(perform: deleteRecommendation) // Add delete functionality
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear All") {
                        clearHistory()
                    }
                }
            }
        }
    }
    // Handle when a recommendation is tapped
    private func handleRecommendationTap(recommendation: Recommendation) {
        // Set the tapped recommendation as the current recommendation
        viewModel.currentRecommendation = recommendation
        viewModel.selectedTab = 1

    }
    // Function to delete individual recommendations
    private func deleteRecommendation(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(recommendations[index])
        }
    }
    
    // Function to clear the entire history
    private func clearHistory() {
        for reco in recommendations {
            modelContext.delete(reco)
        }
    }
}
