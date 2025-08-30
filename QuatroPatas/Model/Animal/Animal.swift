//
//  Animal.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/05/25.
//

struct Animal: Hashable, Identifiable {
    let id: String
    let name: String
    let photo: String? = nil
    let age: String
    let gender: Gender
    let type: AnimalType
    let breed: Breed
    let color: AnimalColor
    let size: AnimalSize? = nil
    let description: String
    var status: AnimalStatus = .readyForAdoption
    var tags: [AnimalTag] = []
}
