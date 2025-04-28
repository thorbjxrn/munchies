import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: Spacings.small) {

            // Restaurant Image
            AsyncImage(url: URL(string: restaurant.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(height: Spacings.titanic)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(Spacings.cornerRadius)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: Spacings.titanic)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(Spacings.cornerRadius)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: Spacings.titanic)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(Spacings.cornerRadius)
                @unknown default:
                    EmptyView()
                }
            }

            // Details
            VStack(alignment: .leading, spacing: Spacings.small / 2) {
                HStack(spacing: Spacings.small) {
                    Text(restaurant.name)
                        .font(.headline)
                    Spacer()
                    Text("★")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", restaurant.rating))
                        .foregroundColor(.secondary)
                }

                HStack(spacing: Spacings.small) {
                    Image(systemName: "clock").foregroundColor(.red)
                    Text("\(restaurant.deliveryTimeMinutes)")
                }
            }
            .padding(.horizontal, Spacings.small)

        }
        .padding(.bottom, Spacings.medium)
    }
}
