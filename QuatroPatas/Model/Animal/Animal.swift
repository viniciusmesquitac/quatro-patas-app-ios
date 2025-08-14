//
//  Animal.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/05/25.
//

struct Animal: Hashable {
    let id: String
    let name: String
    let photo: String? = nil
    let age: String
    let gender: Gender
    let type: AnimalType
    let breed: Breed
    let size: AnimalSize? = nil
    let description: String
    let status: AnimalStatus = .readyForAdoption
}
