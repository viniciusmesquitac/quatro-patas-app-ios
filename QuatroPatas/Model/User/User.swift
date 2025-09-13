//
//  User.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import Foundation

struct User: Hashable, Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let type: UserType
    var createdAt: Date = Date()
}
