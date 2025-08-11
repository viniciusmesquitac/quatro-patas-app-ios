//
//  AnimalFilterView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct AnimalFilter: Hashable {
    var animalType: String?
    var gender: String?
    var breed: String?
    var size: String?
}

struct AnimalFilterView: View {
    @EnvironmentObject var navigator: Navigator
    let animals: [Animal]

    @State var filter: AnimalFilter

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("\(animals.count) disponíveis").font(.headline)) { }

                Section(header: Text("Cachorro ou gato?")) {
                    ForEach(AnimalType.allCases, id: \.self) { type in
                        
                        filterOption(title: type.rawValue, selection: $filter.animalType)
                    }
                }

                Section(header: Text("Qual o gênero?")) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        filterOption(title: gender.rawValue, selection: $filter.gender)
                    }
                }

                Section(header: Text("Qual a raça?")) {
                    ForEach(Breed.allCases, id: \.self) { breed in
                        filterOption(title: breed.rawValue, selection: $filter.breed)
                    }
                }

                Section(header: Text("Porte")) {
                    ForEach(AnimalSize.allCases, id: \.self) { size in
                        filterOption(title: size.rawValue, selection: $filter.size)
                    }
                }

                Section {
                    Button(action: {
                        var filteredAnimals = animals
                        if let gender = filter.gender {
                            filteredAnimals = animals.filter { $0.gender == Gender(rawValue: gender) }
                        }
                        let data = ["animals": filteredAnimals, "filter": filter]
                        navigator.dismiss(data: data)
                    }) {
                        Text("Filtrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }.listRowBackground(Color.clear)
            }
            .navigationTitle("Filtrar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    func filterOption(title: String, selection: Binding<String?>) -> some View {
        Button(action: {
            selection.wrappedValue = title
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
