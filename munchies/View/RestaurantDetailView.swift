import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: restaurant.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }

            Text(restaurant.name)
                .font(.title)
                .bold()

            Text("Rating: \(String(format: "%.1f", restaurant.rating))")
                .font(.subheadline)

            Text("Delivery time: \(restaurant.deliveryTimeMinutes) min")
                .font(.subheadline)

            Spacer()
        }
        .padding()
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
