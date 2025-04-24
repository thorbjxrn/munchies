import Foundation

struct Restaurant: Decodable, Identifiable {
    let id: String
    let name: String
    let imageURL: String
    let deliveryTimeMinutes: Int
    let rating: Double
    let filterIds: [String]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
        case deliveryTimeMinutes = "delivery_time_minutes"
        case rating
        case filterIds
    }
}
