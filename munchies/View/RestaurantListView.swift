import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()

    var body: some View {
        NavigationView {
            VStack() {
                if !viewModel.filters.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacings.small) {
                            ForEach(viewModel.filters) { filter in
                                HStack(spacing: Spacings.small) {
                                    if let urlString = filter.imageURL, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: Spacings.extraLarge, height: Spacings.small)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: Spacings.extraLarge, height: Spacings.extraLarge)
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: Spacings.extraLarge, height: Spacings.extraLarge)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }

                                    Text(filter.name)
                                        .font(.caption)
                                }
                                .padding(.horizontal, Spacings.medium)
                                .padding(.vertical, Spacings.small)
                                .background(viewModel.isFilterSelected(filter.id) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .foregroundColor(viewModel.isFilterSelected(filter.id) ? .blue : .primary)
                                .cornerRadius(Spacings.cornerRadius)
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
                            .padding(.top, Spacings.small)
                        Spacer()
                    }
                    .opacity(viewModel.isLoading ? 1 : 0)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)
                    .frame(height: Spacings.extraLarge)
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
