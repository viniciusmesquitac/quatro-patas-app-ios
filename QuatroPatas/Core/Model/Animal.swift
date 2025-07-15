//
//  Animal.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/05/25.
//

struct Animal {
    let id: String
    let name: String
    let photo: String? = nil
    let age: String
    let gender: Gender
    let type: AnimalType
    let description: String
    var status: AnimalStatus = .readyForAdoption
}

enum AnimalMock {
    static let animals = [
        Animal(
            id: "0",
            name: "Priscila",
            age: "2 anos",
            gender: .female,
            type: .cat,
            description: "Castrado, vermifugado, vacinado."
        ),
        Animal(
            id: "1",
            name: "Luizinha",
            age: "2 anos",
            gender: .female,
            type: .cat,
            description: "Castrado, vermifugado, vacinado."
        ),
        Animal(
            id: "2",
            name: "Maria",
            age: "2 anos",
            gender: .female,
            type: .cat,
            description: "Castrado, vermifugado, vacinado."
        ),
        Animal(
            id: "3",
            name: "Cláudio",
            age: "2 anos",
            gender: .male,
            type: .cat,
            description: "Castrado, vermifugado, vacinado."
        )
    ]
}
