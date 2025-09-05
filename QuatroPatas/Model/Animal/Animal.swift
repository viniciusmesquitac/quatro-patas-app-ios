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
    let gender: String
    let type: String
    let breed: String
    let color: String
    var size: String? = nil
    let description: String
    var status: String?
    var tags: [String] = []
}
