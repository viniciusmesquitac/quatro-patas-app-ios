//
//  AnimalTag.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

enum AnimalTag: String, Localizable, Codable {
    // cat
    case fiv
    case felv

    // dog
    case hipdysplasia

    // common
    case neutered
    case vaccinated
    case microchipped
    case dewormed
    case specialNeeds

    var supportedTypes: [AnimalType] {
        switch self {
        case .fiv, .felv:
            return [.cat]
        case .hipdysplasia:
            return [.dog]
        case .neutered, .vaccinated, .microchipped, .specialNeeds, .dewormed:
            return [.cat, .dog]
        }
    }

    static func localizedByType(_ type: AnimalType) -> [String] {
        allCases
            .filter { $0.supportedTypes.contains(type) }
            .map { AnimalTag.localized($0) }
    }
}
