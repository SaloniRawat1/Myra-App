//
//  MindTherapyData.swift
//

import Foundation

class FitnessData: Codable {

    var fitness: [Fitness] = []

    // Designated initializer
    init(fitness: [Fitness]) {
        self.fitness = fitness
    }

    // Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fitness = try container.decode([Fitness].self, forKey: .fitness)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fitness, forKey: .fitness)
    }

    // Load automatically from JSON
    convenience init() {
        do {
            let response = try Self.load(from: "MindTherapy")
            self.init(fitness: response.fitness)
        } catch {
            print(error.localizedDescription)
            self.init(fitness: [])
        }
    }

    enum CodingKeys: String, CodingKey {
        case fitness = "Fitness"
    }

    func getRandomFitness() -> Fitness? {
        return fitness.randomElement()
    }

    func getFitness(type: String) -> [Fitness] {
        return fitness.filter { $0.category == type }
    }

    func getFitness(type: FitnessCategory) -> [Fitness] {
        return fitness.filter { $0.category == type.rawValue }
    }
}


// MARK: - JSON Loader
extension FitnessData {

    static func load(from filename: String = "MindTherapy") throws -> FitnessData {

        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(
                domain: "FitnessResponse",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "MindTherapy.json not found"]
            )
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        return try decoder.decode(FitnessData.self, from: data)
    }
}


// MARK: - Helpers
extension FitnessData {

    func fitness(for category: FitnessCategory) -> [Fitness] {
        return fitness.filter { $0.category == category.rawValue }
    }

    var fitnessByCategory: [FitnessCategory: [Fitness]] {

        var grouped: [FitnessCategory: [Fitness]] = [:]

        for category in FitnessCategory.allCases {
            grouped[category] = fitness(for: category)
        }

        return grouped
    }
}
