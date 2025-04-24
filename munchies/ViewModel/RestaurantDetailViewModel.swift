import Foundation

@MainActor
class RestaurantDetailViewModel: ObservableObject {
    @Published var isOpen: Bool?
    let restaurant: Restaurant
    let filters: [Filter]
    let urlString = "https://food-delivery.umain.io/api/v1/open/"
    
    init(restaurant: Restaurant, filters: [Filter]) {
        self.restaurant = restaurant
        self.filters = filters
        
        Task {
            await fetchOpenStatus()
        }
    }
    
    var filterNames: [String] {
        restaurant.filterIds.compactMap { id in
            filters.first(where: { $0.id == id })?.name
        }
    }
    
    func fetchOpenStatus() async {
        guard let url = URL(string: urlString + restaurant.id) else {
            assertionFailure("bad url \(urlString + restaurant.id)")
            return
        }
        
        do {
            let result: OpenStatus = try await NetworkService.shared.fetchData(from: url)
            isOpen = result.isOpen
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
