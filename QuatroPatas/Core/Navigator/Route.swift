//
//  Route.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum Route: Identifiable {
    case details(Animal)
    case adoption
    case adoptionForm
    case formPage(FormTemplate, FormManager, Int)
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
    case medicationList(String)
    case annotationList(String)
    case annotationDetails(Annotation)
    case registerAdoption(String)
    case adoptionDetails(String)
    case weightChart(String)
    case reportMissingAnimal
    
    var id: String { String(describing: self) }
}

extension Route: Equatable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case let (.formPage(lForm, _, lPage), .formPage(rForm, _, rPage)):
            return lForm == rForm && lPage == rPage
        default:
            return String(describing: lhs) == String(describing: rhs)
        }
    }
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case let .formPage(form, _, page):
            hasher.combine("formPage")
            hasher.combine(form)
            hasher.combine(page)
        default:
            hasher.combine(String(describing: self))
        }
    }
}
