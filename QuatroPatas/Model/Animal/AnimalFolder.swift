//
//  AnimalFolder.swift
//  QuatroPatas
//

import Foundation
import FirebaseFirestore

struct AnimalFolder: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var createdAt: Date?
}
