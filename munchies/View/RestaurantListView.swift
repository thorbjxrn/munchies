import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            VStack() {
                HStack(alignment: .firstTextBaseline) {
                    Image("umain-logo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.primary)
                        .frame(width: Spacings.massive, height: Spacings.massive)
                        .padding(Spacings.medium)
                    Spacer()
                }
                // filters
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
                                                    .frame(width: Spacings.huge, height: Spacings.huge)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: Spacings.huge, height: Spacings.huge)
                                                    .clipped()
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: Spacings.huge, height: Spacings.huge)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }

                                    Text(filter.name)
                                        .font(.headline)
                                        .padding(.trailing, Spacings.medium)
                                }
                                .background(viewModel.isFilterSelected(filter.id) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .foregroundColor(viewModel.isFilterSelected(filter.id) ? .blue : .primary)
                                .cornerRadius(Spacings.huge)
                                .onTapGesture {
                                    viewModel.toggleFilter(filter.id)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                List(viewModel.filteredRestaurants) { restaurant in
                    ZStack {
                        RestaurantRowView(restaurant: restaurant)
                        NavigationLink(destination: RestaurantDetailView(restaurant: restaurant, filters: viewModel.filters)) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .refreshable {
                    Task {
                        await viewModel.fetchRestaurants()
                        triggerHaptic()
                    }
                }
            }
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
