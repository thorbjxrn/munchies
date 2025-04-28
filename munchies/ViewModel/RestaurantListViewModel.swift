import Foundation
import SwiftUI

@MainActor
class RestaurantListViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filters: [Filter] = []
    @Published var selectedFilterIDs: Set<String> = []
    @Published var isLoading: Bool = false

    var filteredRestaurants: [Restaurant] {
        guard !selectedFilterIDs.isEmpty else { return restaurants }
        return restaurants.filter { restaurant in
            selectedFilterIDs.isSubset(of: restaurant.filterIds)
        }
    }

    func fetchRestaurants() async {
        guard let url = URL(string: "https://food-delivery.umain.io/api/v1/restaurants") else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response: RestaurantsResponse = try await NetworkService.shared.fetchData(from: url)
            self.restaurants = response.restaurants
            await fetchFilters(from: response.restaurants)
        } catch {
            print("❌ Failed to fetch restaurants: \(error.localizedDescription)")
        }
    }

    private func fetchFilters(from restaurants: [Restaurant]) async {
        let uniqueIDs = Set(restaurants.flatMap { $0.filterIds })
        var fetched: [Filter] = []

        await withTaskGroup(of: Filter?.self) { group in
            for id in uniqueIDs {
                group.addTask {
                    guard let url = URL(string: "https://food-delivery.umain.io/api/v1/filter/\(id)") else { return nil }
                    do {
                        return try await NetworkService.shared.fetchData(from: url)
                    } catch {
                        print("⚠️ Failed to fetch filter \(id): \(error.localizedDescription)")
                        return nil
                    }
                }
            }

            for await result in group {
                if let filter = result {
                    fetched.append(filter)
                }
            }
        }

        self.filters = fetched.sorted { $0.name < $1.name }
    }

    func toggleFilter(_ id: String) {
        if selectedFilterIDs.contains(id) {
            selectedFilterIDs.remove(id)
        } else {
            selectedFilterIDs.insert(id)
        }
    }

    func isFilterSelected(_ id: String) -> Bool {
        selectedFilterIDs.contains(id)
    }

    func filterName(for id: String) -> String? {
        filters.first(where: { $0.id == id })?.name
    }
}
