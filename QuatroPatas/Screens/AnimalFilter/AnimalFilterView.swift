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

    @State var filter: AnimalFilter
    
    enum Constants: String, Localizable {
        case navigationTitle
        case formTitle
        case sectionAnimalType
        case sectionGender
        case sectionBreed
        case sectionSize
        case filterButton
    }

    var filteredAnimals: [Animal] {
        animals.filter { animal in
            var matches = true
            if let type = filter.animalType {
                matches = matches && AnimalType.localized(animal.type) == type
            }
            if let gender = filter.gender {
                matches = matches && Gender.localized(animal.gender) == gender
            }
            if let breed = filter.breed {
                matches = matches && Breed.localized(animal.breed) == breed
            }
            if let size = filter.size {
                matches = matches && AnimalSize.localized(animal.size ?? .small) == size
            }
            return matches
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("\(filteredAnimals.count) \(Constants.localized(.formTitle))").font(.headline)) { }

                Section(header: Text(Constants.localized(.sectionAnimalType))) {
                    ForEach(AnimalType.allCases, id: \.self) { type in
                        option(title: AnimalType.localized(type), selection: $filter.animalType)
                    }
                }

                Section(header: Text(Constants.localized(.sectionGender))) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        option(title: Gender.localized(gender), selection: $filter.gender)
                    }
                }

                Section(header: Text(Constants.localized(.sectionBreed))) {
                    ForEach(Breed.allCases, id: \.self) { breed in
                        option(title: Breed.localized(breed), selection: $filter.breed)
                    }
                }

                Section(header: Text(Constants.localized(.sectionSize))) {
                    ForEach(AnimalSize.allCases, id: \.self) { size in
                        option(title: AnimalSize.localized(size), selection: $filter.size)
                    }
                }

                Section {
                    Button(action: {
                        let data: [String: Any] = [
                            "animals": filteredAnimals,
                            "filter": filter
                        ]
                        navigator.dismiss(with: data)
                    }) {
                        Text(Constants.localized(.filterButton) + "(\(filteredAnimals.count))")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }.listRowBackground(Color.clear)
            }
            .navigationTitle(Constants.localized(.navigationTitle))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    func option(title: String, selection: Binding<String?>) -> some View {
        Button(action: {
            selection.wrappedValue = (selection.wrappedValue == title) ? nil : title
        }) {
            HStack {
                Image(systemName: selection.wrappedValue == title ? SFIcons.circle_filled.rawValue : SFIcons.circle.rawValue)
                    .foregroundColor(selection.wrappedValue == title ? .accentColor : .secondary)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
