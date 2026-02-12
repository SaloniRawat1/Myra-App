//
//  entities.swift
//
//  Created by GEU on 03/02/26.
//

import Foundation

struct Fitness: Codable {

    let id: String
    let name: String
    let category: String
    let benefits: [String]
    let level: String
    let duration: String
    let imagePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case benefits
        case level
        case duration
        case imagePath     // JSON key is also imagePath now
    }
}

enum FitnessCategory: String, CaseIterable {
    case yoga = "yoga"
    case exercise = "exercise"

    var displayName: String {
        switch self {
        case .yoga: return "Yoga"
        case .exercise: return "Exercise"
        }
    }
}
