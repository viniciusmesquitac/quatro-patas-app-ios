//
//  Route.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum Route: Hashable, Identifiable {
    case details(Animal)
    case adoption
    case adoptionForm
    case formPage(AdoptionForm, Int)
    case animalsList(AnimalListType)
    case favorites
    case addAnimal
    case edit(Animal)
    case webView(URL)
    case register
    case loginWithEmailAndPassword
    case seeAllAnimals([Animal])
    case profile
    case personalInformation(User)
    case myAnimalDetails(Animal)
    case vaccineList(String)
    case registerAdoption(String)
    case adoptionDetails(String)
    
    var id: String { String(describing: self) }
}
