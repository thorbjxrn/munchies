import SwiftUI

struct RestaurantDetailView: View {
    @StateObject private var viewModel: RestaurantDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var animateEntry = false
    @State private var rotationAngle: Double = 250

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
                            .frame(height: Spacings.immensity)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .scaledToFill()
                            .frame(height: Spacings.immensity)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .frame(height: Spacings.immensity)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                    @unknown default:
                        EmptyView()
                    }
                }
                .rotationEffect(.degrees(rotationAngle))
                .animation(.interpolatingSpring(stiffness: 135, damping: 25), value: animateEntry)
                Spacer()
            }

            // Card view
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
            }
            .padding(Spacings.large)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(Spacings.cornerRadius)
            .padding(.horizontal, Spacings.huge)
            .offset(y: Spacings.immensity - Spacings.massive)
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
        }
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
        .scaleEffect(animateEntry ? 1.0 : 0.80)
        .animation(.interpolatingSpring(stiffness: 85, damping: 100), value: rotationAngle)
        .onAppear {
            animateEntry = true
            rotationAngle = 0
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: Spacings.large, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
