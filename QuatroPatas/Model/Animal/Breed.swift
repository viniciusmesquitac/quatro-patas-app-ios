//
//  Breed.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/08/25.
//

enum Breed: String, Localizable, Codable {
    // common
    case mixed

    // cat
    case siamese
    case persian
    case sphynx
    case mainecoon
    
    // dog
    case labrador
    case golden
    case bulldog
    case beagle
    case poodle
    case bordercollie
    case dalmata

    var supportedTypes: [AnimalType] {
        switch self {
        case .siamese, .persian, .sphynx, .mainecoon:
            return [.cat]
        case .labrador, .bulldog, .poodle, .golden, .bordercollie, .beagle, .dalmata:
            return [.dog]
        case .mixed:
            return [.cat, .dog]
        }
    }

    static func localizedByType(_ type: AnimalType) -> [String] {
        allCases
            .filter { $0.supportedTypes.contains(type) }
            .map { Breed.localized($0) }
    }
}
