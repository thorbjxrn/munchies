import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RestaurantViewModel()

    var body: some View {
        NavigationView {
            Group {
                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.restaurants) { restaurant in
                        NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                                    RestaurantRowView(restaurant: restaurant)
                                                }
                    }
                }
            }
            .navigationTitle("U *")
            .onAppear {
                Task {
                    await viewModel.fetchRestaurants()
                }
            }
        }
    }
}
