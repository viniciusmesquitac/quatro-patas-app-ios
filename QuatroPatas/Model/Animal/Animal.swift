//
//  Animal.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/05/25.
//

@preconcurrency import FirebaseFirestore

struct Animal: Hashable, Identifiable, Sendable, Codable {
    @DocumentID var id: String?
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
}

extension Animal {
    static let empty = Animal(name: "", age: "", gender: "", type: "", breed: "", color: "", size: "", description: "")
}
