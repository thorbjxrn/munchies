import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter pills
                if !viewModel.filters.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.filters) { filter in
                                Text(filter.name)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(viewModel.isFilterSelected(filter.id) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                    .foregroundColor(viewModel.isFilterSelected(filter.id) ? .blue : .primary)
                                    .cornerRadius(16)
                                    .onTapGesture {
                                        viewModel.toggleFilter(filter.id)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Restaurant list
                List(viewModel.filteredRestaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        RestaurantRowView(restaurant: restaurant)
                    }
                }
                .listStyle(.plain)
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
