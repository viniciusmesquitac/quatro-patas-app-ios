//
//  Sheet.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum Sheet: Identifiable {
    case animalFilter([Animal], Binding<AnimalFilter>)
    case share(items: [Any])
    case tip(Tip)
    case logout
    case deleteAnimal(Animal, onDelete: (DeleteAction) -> Void)
    case alert(title: String, action: () -> Void)
    case descriptionEditor(Binding<String>)
    case addAnimal
    case addVaccine(animalId: String, onAdded: () -> Void)
    case addMedication(animalId: String, onAdded: () -> Void)
    case addWeight(animalId: String, onAdded: (WeightEntry) -> Void)
    case addAnnotation(animalId: String, onAdded: () -> Void)
    case map(address: Binding<String>)

    var id: String {  String(describing: self) }
}
