struct Filter: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
    }
}
