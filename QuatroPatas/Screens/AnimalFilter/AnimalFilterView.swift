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
                        CustomDropdown(
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
                        CustomDropdown(
                            title: Constants.localized(.sectionBreed),
                            options: Breed.allCases.map { Breed.localized($0) },
                            selection: Binding(
                                get: { filter.breed ?? "Selecione" },
                                set: { newValue in filter.breed = newValue }
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
struct CustomDropdown: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            // Label do dropdown
            Button(action: {
                withAnimation(.bouncy) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selection.isEmpty ? title : selection)
                        .foregroundColor(selection.isEmpty || selection == "Selecione" ? .primary : Color.primaryColor)
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(selection.isEmpty || selection == "Selecione" ? .secondary : Color.primaryColor)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(selection.isEmpty || selection == "Selecione" ? Color.gray.opacity(0.2): Color.primaryColor.opacity(0.2))
                .cornerRadius(12)
            }
            .buttonStyle(FilterButtonStyle()) // tira highlight default do botão
            
            // Lista de opções
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                selection = option
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(selection == option ? Color.primaryColor : .primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(selection == option ? Color.primaryColor.opacity(0.2) : Color.clear)
                            .contentShape(Rectangle()) // <-- toda a área vira clicável
                        }
                        .buttonStyle(FilterButtonStyle()) // mantém o estilo liso
                        
                        if option != options.last {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
            }
        }
    }
}
