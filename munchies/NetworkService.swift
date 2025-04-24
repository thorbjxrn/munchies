import Foundation

class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        let session = URLSession(configuration: configuration)

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

struct RestaurantsResponse: Decodable {
    let restaurants: [Restaurant]
}
