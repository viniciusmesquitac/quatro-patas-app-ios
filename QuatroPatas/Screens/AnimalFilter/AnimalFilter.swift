//
//  AnimalFilter.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/08/25.
//

struct AnimalFilter: Hashable {
    var animalType: String?
    var gender: String?
    var breed: String?
    var size: String?
    var color: String?
}

extension AnimalFilter: Filter {

    typealias Item = Animal

    func apply(to items: [Animal]) -> [Animal] {
        items.filter { animal in
            var matches = true
            if let type = animalType {
                matches = matches && animal.type == AnimalType.fromLocalized(type)?.caseName
            }
            if let gender = gender {
                matches = matches && animal.gender == Gender.fromLocalized(gender)?.caseName
            }
            if let breed = breed {
                matches = matches && animal.breed == Breed.fromLocalized(breed)?.caseName
            }
            if let size = size {
                matches = matches && animal.size == AnimalSize.fromLocalized(size)?.caseName
            }

            if let color = color {
                matches = matches && animal.color == AnimalColor.fromLocalized(color)?.caseName
            }

            return matches
        }
    }

    mutating func remove(value: String) {
        if animalType == value {
            animalType = nil
        } else if gender == value {
            gender = nil
        } else if breed == value {
            breed = nil
        } else if size == value {
            size = nil
        } else if color == value {
            color = nil
        }
    }
    
}
