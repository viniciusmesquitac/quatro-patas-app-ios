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
        case formTitle
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
            Form {
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
            }
            .navigationTitle(Constants.localized(.navigationTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarItem(icon: .close,placement: .topBarTrailing) {
                navigator.dismiss()
            }
    
            Button(action: {
                navigator.dismiss()
            }) {
                Text(Constants.localized(.filterButton) + " (\(filteredAnimals.count))")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(CornerRadius.small.rawValue)
                    .padding(.horizontal)
                    .padding(.vertical, Padding.medium.rawValue)
            }
            .background(.clear)
        }
    }

    @ViewBuilder
    func option(title: String, selection: Binding<String?>) -> some View {
        Button(action: {
            selection.wrappedValue = (selection.wrappedValue == title) ? nil : title
        }) {
            HStack {
                Image(systemName: selection.wrappedValue == title ? SFIcon.circle_filled.rawValue : SFIcon.circle.rawValue)
                    .foregroundColor(selection.wrappedValue == title ? .primaryColor : .secondary)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
