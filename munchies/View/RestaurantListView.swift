import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 8)
                        Spacer()
                    }
                    .opacity(viewModel.isLoading ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
                    .frame(height: 40)
                }

                List(viewModel.filteredRestaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant, filters: viewModel.filters)) {
                        RestaurantRowView(restaurant: restaurant)
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    Task {
                        await viewModel.fetchRestaurants()
                        triggerHaptic()
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

    private func triggerHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
