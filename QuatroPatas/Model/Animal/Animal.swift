//
//  Animal.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/05/25.
//

@preconcurrency import FirebaseFirestore

struct Animal: Hashable, Identifiable, Sendable, Codable, Equatable {
    @DocumentID var id: String?
    var fileId: String?
    @ServerTimestamp var createdAt: Date?
    var name: String
    var photos: [String] = []
    var age: String
    var gender: String
    var type: String
    var breed: String
    var color: String
    var size: String
    var description: String
    var status: String?
    var tags: [String] = []
    var isAdopted: Bool = false
    var isMissing: Bool = false
    var ownerId: String?
    var adoptionTerm: String?
    var position: Int?
    var folder: String?
}

extension Animal {
    static let empty = Animal(name: "", photos: ["https://via.placeholder.com/150"], age: "", gender: "", type: "", breed: "", color: "", size: "", description: "")
}

extension Animal {
    var localized: Animal {
        var copy = self
        copy.breed = Breed.localized(Breed(rawValue: self.breed) ?? .mixed)
        copy.color = AnimalColor.localized(AnimalColor(rawValue: self.color) ?? .black)
        copy.gender = Gender.localized(Gender(rawValue: self.gender) ?? .female)
        copy.size = AnimalSize.localized(AnimalSize(rawValue: self.size) ?? .small)
        copy.type = AnimalType.localized(AnimalType(rawValue: self.type) ?? .cat)
        copy.tags = self.tags
            .compactMap { AnimalTag(rawValue: $0) }
            .map { AnimalTag.localized($0) }
        return copy
    }

    var ageFormatted: String {
        AgeHelper.formatAge(from: age)
    }
}

extension Animal {
    var deslocalized: Animal {
        var copy = self
        copy.gender = Gender.fromLocalized(self.gender)?.caseName ?? ""
        copy.type   = AnimalType.fromLocalized(self.type)?.caseName ?? ""
        copy.breed  = Breed.fromLocalized(self.breed)?.caseName ?? ""
        copy.color  = AnimalColor.fromLocalized(self.color)?.caseName ?? ""
        copy.size   = AnimalSize.fromLocalized(self.size)?.caseName ?? ""
        copy.tags   = self.tags.compactMap { AnimalTag.fromLocalized($0)?.caseName }
        return copy
    }
}
