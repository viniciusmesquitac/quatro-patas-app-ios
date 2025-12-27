//
//  Adoption.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 22/09/25.
//

@preconcurrency import FirebaseFirestore

struct Adoption: Identifiable, Codable, Hashable, Sendable {
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?

    var animalId: String
    var termPhoto: String?
    var idPhotoFront: String?
    var idPhotoBack: String?

    var status: AdoptionStatus
}
