import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: Spacings.small) {

            // Restaurant Image
            AsyncImage(url: URL(string: restaurant.imageURL)) { phase in
                asyncImageContent(for: phase)
            }
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
            .clipped()

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

    @ViewBuilder
    private func asyncImageContent(for phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            ProgressView()
                .background(Color.gray.opacity(0.2))
        case .success(let image):
            image
                .resizable()
                .scaledToFill()
        case .failure:
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .background(Color.gray.opacity(0.2))
        @unknown default:
            EmptyView()
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
