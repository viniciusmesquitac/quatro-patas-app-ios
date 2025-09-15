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
    case menu
    case adoption
    case adoptionForm
    case formPage(AdoptionForm, Int)
    case animalsList
    case addAnimal
    case edit(Animal, Int, Int)
    case webView(URL)
    case register
    case loginWithEmailAndPassword
    
    var id: String { String(describing: self) }
}
