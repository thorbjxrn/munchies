import Foundation
import SwiftUI

@MainActor
class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var errorMessage: String?

    private let endpoint = "https://food-delivery.umain.io/api/v1/restaurants"

    /// Asynchronously fetch the list of restaurants.
    func fetchRestaurants() async {
        guard let url = URL(string: endpoint) else {
            errorMessage = "Invalid URL."
            return
        }

        do {
            let response: RestaurantsResponse = try await NetworkService.shared.fetchData(from: url)
            restaurants = response.restaurants
            errorMessage = nil
        } catch {
            restaurants = []
            errorMessage = "Failed to load: \(error.localizedDescription)"
        }
    }
}
