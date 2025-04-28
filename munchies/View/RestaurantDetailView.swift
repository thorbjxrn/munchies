import SwiftUI

struct RestaurantDetailView: View {
    @StateObject private var viewModel: RestaurantDetailViewModel

    init(restaurant: Restaurant, filters: [Filter]) {
        _viewModel = StateObject(wrappedValue: RestaurantDetailViewModel(restaurant: restaurant, filters: filters))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            AsyncImage(url: URL(string: viewModel.restaurant.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView().frame(height: Spacings.immensity)
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill).frame(height: Spacings.immensity).clipped()
                case .failure:
                    Image(systemName: "photo").frame(height: Spacings.immensity)
                @unknown default:
                    EmptyView()
                }
            }

            Text(viewModel.restaurant.name)
                .font(.title)
                .bold()

            if !viewModel.filterNames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.filterNames, id: \.self) { name in
                            Text(name)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(Spacings.cornerRadius)
                                .font(.caption)
                        }
                    }
//                    .padding(.bottom, )
                }
            }

            if let isOpen = viewModel.isOpen {
                Text(isOpen ? "Open" : "Closed")
                    .font(.headline)
                    .foregroundColor(isOpen ? .green : .red)
            } else {
                ProgressView("Checking status...")
            }

            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
