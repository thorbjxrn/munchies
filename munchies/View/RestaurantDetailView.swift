import SwiftUI

struct RestaurantDetailView: View {
    @StateObject private var viewModel: RestaurantDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(restaurant: Restaurant, filters: [Filter]) {
        _viewModel = StateObject(wrappedValue: RestaurantDetailViewModel(restaurant: restaurant, filters: filters))
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                // Top big Image
                AsyncImage(url: URL(string: viewModel.restaurant.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                    @unknown default:
                        EmptyView()
                    }
                }
                Spacer()
            }

            VStack(alignment: .leading, spacing: Spacings.medium) {
                Text(viewModel.restaurant.name)
                    .font(.title)
                    .bold()

                if !viewModel.filterNames.isEmpty {
                    Text(viewModel.filterNames.joined(separator: " • "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let isOpen = viewModel.isOpen {
                    Text(isOpen ? "Open" : "Closed")
                        .font(.subheadline)
                        .foregroundColor(isOpen ? .green : .red)
                } else {
                    ProgressView("Checking status...")
                        .font(.subheadline)
                }

                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(Spacings.cornerRadius)
            .offset(y: Spacings.immensity)
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
