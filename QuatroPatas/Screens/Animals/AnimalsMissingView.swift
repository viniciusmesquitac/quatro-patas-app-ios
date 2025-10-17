//
//  AnimalsMissingView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 10/10/25.
//

import SwiftUI

struct AnimalsMissingView: View {

    @State private var animals: [Animal] = []
    @State private var isLoading = true

    @EnvironmentObject var databaseProvider: DatabaseProvider
    @Environment(\.toast) var toast
    
    private let columns = [
        GridItem(.adaptive(minimum: 170), spacing: Spacing.medium.rawValue)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Padding.xLarge.rawValue) {
            ForEach(animals, id: \.id) { animal in
                AnimalCardView(animal: animal) {
                    
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .onAppear {
            Task {
                await fetchMissingAnimals()
            }
        }
        .padding(.horizontal, Padding.large.rawValue)
        .if(animals.isEmpty && isLoading == false) { view in
            view.emptyState(.search)
        }
    }
    
    @MainActor
    private func fetchMissingAnimals() async {
        isLoading = true
        do {
            // Busca apenas da ong quatro patas
            let ongId = "7IicBiq4WcVD6VG5N6V32wPsE5Y2"
            let animals: [Animal] = try await databaseProvider.fetch(from: "users/\(ongId)/animals") {
                $0
                    .whereField("isMissing", isEqualTo: true)
                    .whereField("isAdopted", isEqualTo: false)
                    .order(by: "position", descending: false)
            }
            withAnimation(.spring()) {
                self.animals = animals
            }
            isLoading = false
        } catch {
            toast(error.localizedDescription, .error)
            isLoading = false
        }
    }
}
