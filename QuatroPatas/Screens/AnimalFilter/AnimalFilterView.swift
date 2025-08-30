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
    
    enum Constants: String, Localizable {
        case navigationTitle
        case sectionAnimalType
        case sectionGender
        case sectionBreed
        case sectionSize
        case sectionColor
        case filterButton
    }
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Tipo
                    filterSection(title: Constants.localized(.sectionAnimalType)) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(AnimalType.allCases, id: \.self) { type in
                                SelectableButton(
                                    title: AnimalType.localized(type),
                                    isSelected: filter.animalType == AnimalType.localized(type)
                                ) {
                                    filter.animalType = (filter.animalType == AnimalType.localized(type)) ? nil : AnimalType.localized(type)
                                }
                            }
                        }
                    }
                    
                    // MARK: Gênero
                    filterSection(title: Constants.localized(.sectionGender)) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                SelectableButton(
                                    title: Gender.localized(gender),
                                    isSelected: filter.gender == Gender.localized(gender)
                                ) {
                                    filter.gender = (filter.gender == Gender.localized(gender)) ? nil : Gender.localized(gender)
                                }
                            }
                        }
                    }
                    
                    // MARK: Porte
                    filterSection(title: Constants.localized(.sectionSize)) {
                        Dropdown(
                            title: Constants.localized(.sectionSize),
                            options: AnimalSize.allCases.map { AnimalSize.localized($0) },
                            selection: Binding(
                                get: { filter.size ?? "Selecione" },
                                set: { newValue in filter.size = newValue }
                            )
                        )
                    }
                    
                    // MARK: Raça
                    filterSection(title: Constants.localized(.sectionBreed)) {
                        Dropdown(
                            title: Constants.localized(.sectionBreed),
                            options: Breed.allCases.map { Breed.localized($0) },
                            selection: Binding(
                                get: { filter.breed ?? "Selecione" },
                                set: { newValue in filter.breed = newValue }
                            )
                        )
                    }
                    
                    // MARK: Cor
                    filterSection(title: Constants.localized(.sectionColor)) {
                        Dropdown(
                            title: Constants.localized(.sectionColor),
                            options: AnimalColor.allCases.map { AnimalColor.localized($0) },
                            selection: Binding(
                                get: { filter.color ?? "Selecione" },
                                set: { newValue in filter.color = newValue }
                            )
                        )
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button(action: {
                        navigator.dismiss()
                    }) {
                        Text(Constants.localized(.filterButton) + " (\(filteredAnimals.count))")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(CornerRadius.small.rawValue)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial) // dá um blurzinho igual iOS nativo
            }
            .navigationTitle(Constants.localized(.navigationTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                navigator.dismiss()
            }
        }
    }
    
    // MARK: View auxiliar para título de seção
    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            content()
        }
    }
}

// MARK: Botão de seleção customizado
struct SelectableButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .frame(maxWidth: .infinity, minHeight: 50) // garante metade da largura
                .background(isSelected ? Color.primaryColor.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .primaryColor : .primary)
                .cornerRadius(12)
        }
        .buttonStyle(FilterButtonStyle())
    }
}
