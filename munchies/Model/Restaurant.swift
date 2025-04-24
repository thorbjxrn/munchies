import Foundation

struct Restaurant: Codable, Identifiable {
    let filterIds: [String]
    let imageURL: String
    let id: String
    let deliveryTimeMinutes: Int
    let name: String
    let rating: Double

    private enum CodingKeys: String, CodingKey {
        case filterIds
        case imageURL = "image_url"
        case id
        case deliveryTimeMinutes = "delivery_time_minutes"
        case name
        case rating
    }
}
