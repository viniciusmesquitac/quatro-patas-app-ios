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
    case adoption
    case animalsList(AnimalListType)
    case favorites
    case addAnimal
    case edit(Animal)
    case webView(URLRequest)
    case register
    case login
    case loginWithEmailAndPassword
    case forgotPassword
    case profile
    case personalInformation(User)
    case animalWallet(Animal)
    case vaccineList(String)
    case medicationList(String)
    case annotationList(String)
    case annotationDetails(Annotation, String)
    case registerAdoption(String)
    case adoptionDetails(String)
    case weightChart(String)
    case reportMissingAnimal
    case happyEndingDetails(imageUrl: String)

    var id: String { String(describing: self) }
}
