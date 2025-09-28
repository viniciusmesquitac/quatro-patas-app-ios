//
//  Untitled.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/08/25.
//


import SwiftUI

struct SheetDestinationView: View {
    let sheet: Sheet

    var body: some View {
        switch sheet {
        case .animalFilter(let animals, let filter):
            AnimalFilterView(animals: animals, filter: filter)
        case .share(let items):
            ShareSheet(items: items)
        case .tip(let tip):
            TipView(tip: tip)
        case .logout:
            LogoutView()
        case .alert(let title, let action):
            AlertView(title: title, action: action)
        case .deleteAnimal(let animal, let onDelete):
            DeleteAnimalView(animal: animal, onDelete: onDelete)
        case .addVaccine(let animalId, let onAdded):
            NavigationStack {
                AddVaccineView(animalId: animalId, onAdded: onAdded)
                    .modifier(ToastModifier())
            }
        case .descriptionEditor(let text):
            NavigationStack {
                DescriptionEditorView(text: text)
            }
        }
    }
}
