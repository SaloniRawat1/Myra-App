import Foundation

struct Mind: Codable {

    let id: String
    let name: String
    let category: String
    let benefits: [String]
    let duration: String
    let imagePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case benefits
        case duration
        case imagePath
    }
}


enum MindCategory: String, CaseIterable {

    case musicTherapy = "musicTherapy"
    case meditation = "meditation"

    var displayName: String {
        switch self {
        case .musicTherapy:
            return "Music Therapy"
        case .meditation:
            return "Meditation"
        }
    }
}
