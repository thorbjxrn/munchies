import Foundation

struct OpenStatus: Decodable {
    let isOpen: Bool

    private enum CodingKeys: String, CodingKey {
        case isOpen = "is_currently_open"
    }
}
