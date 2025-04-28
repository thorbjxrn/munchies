import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant
    let filters: [Filter]

    var body: some View {
        VStack() {
            // Restaurant Image
            AsyncImage(url: URL(string: restaurant.imageURL)) { phase in
                asyncImageContent(for: phase)
            }
            .scaledToFill()
            .clipShape(RoundedCorner(radius: Spacings.cornerRadius, corners: [.topLeft, .topRight]))

            // Details
            VStack(alignment: .leading, spacing: Spacings.small) {
                HStack(spacing: Spacings.small) {
                    Text(restaurant.name)
                        .font(.title3)
                    Spacer()
                    Text("★")
                        .foregroundColor(.yellow)
                        .font(.footnote)
                    Text(String(format: "%.1f", restaurant.rating))
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }

                if !filters.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacings.small) {
                            ForEach(filters) { filter in
                                Text(filter.name)
                                    .font(.footnote)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: Spacings.small) {
                    Image(systemName: "clock").foregroundColor(.red)
                    Text("\(restaurant.deliveryTimeMinutes) min")
                }
            }
            .padding(.horizontal, Spacings.small)
            .padding(.bottom, Spacings.small)
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedCorner(radius: Spacings.cornerRadius, corners: [.topLeft, .topRight]))
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
        .padding(Spacings.small)
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
