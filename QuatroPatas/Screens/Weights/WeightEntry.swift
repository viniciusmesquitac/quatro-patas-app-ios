//
//  WeightEntry.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/10/25.
//

@preconcurrency import FirebaseFirestore

struct WeightEntry: Codable, Identifiable {
    @DocumentID var id: String?
    let date: Date
    let weight: Double
}
