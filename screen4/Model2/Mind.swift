//
//  Mind.swift
//

import Foundation

class MindTherapyData: Codable {

    var mind: [Mind]

    // MARK: - Designated initializer
    init(mind: [Mind]) {
        self.mind = mind
    }

    // MARK: - Codable

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mind = try container.decode([Mind].self, forKey: .mind)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mind, forKey: .mind)
    }

    enum CodingKeys: String, CodingKey {
        case mind = "Mind"
    }

    // MARK: - Auto load from JSON

    convenience init() {
        do {
            let response = try Self.load(from: "Mind")
            self.init(mind: response.mind)
        } catch {
            print(error.localizedDescription)
            self.init(mind: [])
        }
    }

    // MARK: - Helpers

    func getRandomMind() -> Mind? {
        return mind.randomElement()
    }

    func getMind(type: String) -> [Mind] {
        return mind.filter { $0.category == type }
    }

    func getMind(type: MindCategory) -> [Mind] {
        return mind.filter { $0.category == type.rawValue }
    }
}


// MARK: - JSON Loader
extension MindTherapyData {

    static func load(from filename: String = "Mind") throws -> MindTherapyData {

        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(
                domain: "MindTherapyData",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "\(filename).json not found"]
            )
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        return try decoder.decode(MindTherapyData.self, from: data)
    }
}


// MARK: - Category helpers
extension MindTherapyData {

    func mind(for category: MindCategory) -> [Mind] {
        return mind.filter { $0.category == category.rawValue }
    }

    var mindByCategory: [MindCategory: [Mind]] {

        var grouped: [MindCategory: [Mind]] = [:]

        for category in MindCategory.allCases {
            grouped[category] = mind(for: category)
        }

        return grouped
    }
}
