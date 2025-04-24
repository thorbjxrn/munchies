import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: restaurant.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 60, height: 60)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.headline)
                Text("Delivery: \(restaurant.deliveryTimeMinutes) min")
                    .font(.subheadline)
            }
            Spacer()
            Text(String(format: "%.1f", restaurant.rating))
                .font(.title3)
                .foregroundColor(.blue)
        }
        .contentShape(Rectangle())
        .padding(4)
    }
}
