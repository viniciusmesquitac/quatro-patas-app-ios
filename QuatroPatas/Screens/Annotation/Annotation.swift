//
//  Annotation.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/10/25.
//

@preconcurrency import FirebaseFirestore

struct Annotation: Hashable, Codable, Identifiable {
    @DocumentID var id: String?
    var text: String
    var date: String
}
