import SwiftUI

struct RestaurantDetailView: View {
    @StateObject private var viewModel: RestaurantDetailViewModel

    init(restaurant: Restaurant) {
        _viewModel = StateObject(wrappedValue: RestaurantDetailViewModel(restaurant: restaurant))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: viewModel.restaurant.imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView().frame(height: 200)
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill).frame(height: 200).clipped()
                case .failure:
                    Image(systemName: "photo").frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }

            Text(viewModel.restaurant.name)
                .font(.title)
                .bold()

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
