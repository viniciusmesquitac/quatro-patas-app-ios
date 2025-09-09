//
//  AnimalFilterView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct AnimalFilterView: View {
    @EnvironmentObject var navigator: Navigator
    let animals: [Animal]
    @Binding var filter: AnimalFilter
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    var filterElement: [FormElement] {
        [
            .selectable(title: "Cachorro ou gato?", options: AnimalType.allLocalized, binding: Binding<String>(
                get: { filter.animalType ?? String() },
                set: { filter.animalType = $0 }
            )),
            .selectable(title:  "Macho ou fêmea?", options: Gender.allLocalized, binding: Binding<String>(
                get: { filter.gender ?? String() },
                set: { filter.gender = $0 }
            )),
            .dropdown(title: "Qual Porte?", options: AnimalSize.allLocalized, binding: Binding(
                get: { filter.size ?? "Selecione" },
                set: { newValue in filter.size = newValue }
            )),
            .dropdown(title: "Qual Raça?", options: Breed.allLocalized, binding: Binding(
                get: { filter.breed ?? "Selecione" },
                set: { newValue in filter.breed = newValue }
            )),
            .dropdown(title: "Qual Cor?", options: AnimalColor.allLocalized, binding: Binding(
                get: { filter.color ?? "Selecione" },
                set: { newValue in filter.color = newValue }
            ))
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                DynamicFormView(elements: filterElement)
                    .padding(Padding.xxLarge.rawValue)
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button(action: {
                        navigator.dismiss()
                    }) {
                        Text("Filtrar" + " (\(filteredAnimals.count))")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(CornerRadius.small.rawValue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, Padding.medium.rawValue)
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Filtrar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                navigator.dismiss()
            }
        }
    }
}
