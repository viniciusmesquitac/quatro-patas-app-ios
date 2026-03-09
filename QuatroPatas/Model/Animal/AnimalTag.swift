//
//  AnimalTag.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

enum AnimalTag: String, Localizable, Codable, CaseIterable {
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

    func makeTagItem(using navigator: Navigator) -> TagItem {
        let action: () -> Void
        switch self {
        case .vaccinated:
            action = { navigator.present(sheet: .tip(.vaccinated)) }
        case .neutered:
            action = { navigator.present(sheet: .tip(.neutered)) }
        case .felv:
            action = { navigator.present(sheet: .tip(.felv)) }
        case .dewormed:
            action = { navigator.present(sheet: .tip(.dewormed)) }
        case .fiv:
            action = { navigator.present(sheet: .tip(.fiv)) }
        default:
            action = {}
        }
        return TagItem(tag: self, action: nil)
    }
}
