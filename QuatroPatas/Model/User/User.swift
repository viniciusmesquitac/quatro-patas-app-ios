//
//  User.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

struct User: Hashable, Identifiable {
    let id: String
    let name: String
    let email: String
    let type: UserType
}
