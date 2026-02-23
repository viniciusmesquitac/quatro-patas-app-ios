//
//  Place.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct Place: Identifiable, Hashable {
    let id = UUID()
    let city: String
    let state: String
}
