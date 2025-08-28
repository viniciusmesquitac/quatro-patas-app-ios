//
//  Route.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum Route: Hashable, Identifiable {
    case animals
    case details(Animal)
    case profile(User)
    case adoption
    case adoptionForm
    case formPage(AdoptionForm)
    
    var id: String { String(describing: self) }
}
