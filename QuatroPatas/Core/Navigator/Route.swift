//
//  Route.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI
import WebKit

enum Route: Identifiable, Hashable {
    case details(Animal)
    case favorites
    case addAnimal
    case edit(Animal)
    case register
    case login
    case loginWithEmailAndPassword
    case forgotPassword
    case profile
    case personalInformation(User)
    case formsInformation(User)
    case animalWallet(Animal)
    case vaccineList(String)
    case medicationList(String)
    case annotationList(String)
    case annotationDetails(Annotation, String)
    case registerAdoption(String)
    case adoptionDetails(String)
    case weightChart(String)
    case reportMissingAnimal
    case ngoDetails(User)

    var id: String { String(describing: self) }
}
