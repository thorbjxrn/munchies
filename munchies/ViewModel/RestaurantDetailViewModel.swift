import Foundation

@MainActor
class RestaurantDetailViewModel: ObservableObject {
    @Published var isOpen: Bool?
    let restaurant: Restaurant
    let urlString = "https://food-delivery.umain.io/api/v1/open/"

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        Task {
            await fetchOpenStatus()
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
