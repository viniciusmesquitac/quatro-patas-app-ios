//
//  IncludeAnimalsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/01/26.
//

import SwiftUI

struct IncludeAnimalsView: View {

    @Binding var includedAnimals: [Animal]

    @State private var selectedRows: Set<Animal.ID> = []
    @State private var animals: [Animal] = []
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(animals, id: \.id) { animal in
                    SelectableAnimalRow(
                        animal: animal,
                        isSelected: selectedRows.contains(animal.id)
                    ) {
                        toggleSelection(for: animal)
                    }
                }
            }
            .task {
                await fetchAllAnimals()
            }
            .toolbarItem(label: "Fechar", placement: .topBarLeading) {
                isPresented = false
            }.toolbarItem(label: "Confirmar", placement: .topBarTrailing) {
                includedAnimals = animals.filter {
                    selectedRows.contains($0.id)
                }
                isPresented = false
            }
        }.navigationTitle("Incluir Animais")
    }

    private func toggleSelection(for animal: Animal) {
        if selectedRows.contains(animal.id) {
            selectedRows.remove(animal.id)
        } else {
            selectedRows.insert(animal.id)
        }
    }
    
    @MainActor
    func fetchAllAnimals() async {
        do {
            let userId = userSession.user?.id ?? ""
            let items: [Animal] = try await databaseProvider.fetch(from: "users/\(userId)/animals")
            self.animals = items
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }
}
