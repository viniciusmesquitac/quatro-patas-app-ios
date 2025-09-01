//
//  Animal.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/05/25.
//

@preconcurrency import FirebaseFirestore

struct Animal: Hashable, Identifiable, Sendable, Codable {
    @DocumentID var id: String?
    let name: String
    var photos: [String] = []
    let age: String
    let gender: Gender
    let type: AnimalType
    let breed: Breed
    let color: AnimalColor
    var size: AnimalSize? = nil
    let description: String
    var status: AnimalStatus?
    var tags: [AnimalTag] = []
}
