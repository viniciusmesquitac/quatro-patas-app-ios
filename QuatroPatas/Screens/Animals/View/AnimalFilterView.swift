//
//  AnimalFilterView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct AnimalFilterView: View {
    @Environment(\.dismiss) var dismiss

    @State private var selectedAnimalType: String? = nil
    @State private var selectedGender: String? = nil
    @State private var selectedBreed: String? = nil
    @State private var selectedSize: String? = nil
    @State private var selectedColor: String? = nil

    let breeds = ["Sem raça definida", "Labrador", "Siamês"]
    let sizes = ["Pequeno", "Médio", "Grande"]
    let colors = ["Preto", "Branco", "Caramelo", "Cinza", "Mesclado"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("41 disponíveis").font(.headline)) {}

                Section(header: Text("Cachorro ou gato?")) {
                    filterOption(title: "Cachorro", selection: $selectedAnimalType)
                    filterOption(title: "Gato", selection: $selectedAnimalType)
                }

                Section(header: Text("Qual o gênero?")) {
                    filterOption(title: "Macho", selection: $selectedGender)
                    filterOption(title: "Fêmea", selection: $selectedGender)
                }

                Section(header: Text("Qual a raça?")) {
                    ForEach(breeds, id: \.self) { breed in
                        filterOption(title: breed, selection: $selectedBreed)
                    }
                }

                Section(header: Text("Porte")) {
                    ForEach(sizes, id: \.self) { size in
                        filterOption(title: size, selection: $selectedSize)
                    }
                }

                Section(header: Text("Cor")) {
                    ForEach(colors, id: \.self) { color in
                        filterOption(title: color, selection: $selectedColor)
                    }
                }

                Section {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Filtrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Filtrar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    @ViewBuilder
    func filterOption(title: String, selection: Binding<String?>) -> some View {
        Button(action: {
            if selection.wrappedValue == title {
                selection.wrappedValue = nil
            } else {
                selection.wrappedValue = title
            }
        }) {
            HStack {
                Text(title)
                Spacer()
                if selection.wrappedValue == title {
                    SFIcons.image(.checkmark)
                }
            }
        }
        .foregroundColor(.primary)
    }
}
