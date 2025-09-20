//
//  User.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import Foundation

struct User: Hashable, Identifiable, Codable {
    let id: String
    var name: String
    let email: String
    var phone: String?
    var instagram: String?
    let type: UserType
    var createdAt: Date = Date()
}
