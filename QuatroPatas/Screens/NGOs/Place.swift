//
//  Place.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct Place: Identifiable, Equatable {
    let id = UUID()
    let city: String
    let state: String

    var isDefault: Bool {
        city == "Default" && state == "Default"
    }
}
