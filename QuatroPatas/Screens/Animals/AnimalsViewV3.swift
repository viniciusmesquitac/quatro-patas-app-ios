//
//  AnimalsViewV3.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 30/09/25.
//

import SwiftUI

struct AnimalsViewV3: View {
    
    @State private var animals: [Animal] = []
    @State private var filter = AnimalFilter()

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @Environment(\.toast) var toast

    @State private var selectedSegment: AnimalsSegment = .available
    @State private var isLoading = true
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }

    var body: some View {
        ScrollView {
            CustomSegmentedPicker(
                selection: $selectedSegment,
                primaryColor: .primaryColor
            ).padding()
            
            switch selectedSegment {
            case .available: availables
            case .lost: missing
            @unknown default: EmptyView()
            }
        }
        .onAppear {
            Task {
                await fetchAllAnimals()
            }
        }
        .toolbar {
            if selectedSegment == .available {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigator.present(sheet: .animalFilter(animals, $filter))
                    } label: {
                        SFIcon.image(.filter)
                    }
                }
            }
        }
        .navigationTitle("Animais")
    }
    
    var availables: some View {
        VStack {
            if !filter.isEmpty {
                FilterView(filter: $filter)
                    .padding(.bottom, Padding.medium.rawValue)
            }
            ForEach(Array(filteredAnimals.prefix(4)), id: \.id) { animal in
                AnimalRowView(animal: animal) {
                    navigator.navigate(to: .details(animal))
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
                .padding(.horizontal, Padding.large.rawValue)
            }
            if !filteredAnimals.isEmpty {
                Button("Ver todos") {
                    navigator.navigate(to: .seeAllAnimals(animals))
                }.padding(.vertical, Padding.medium.rawValue)
            }
        }.if(filteredAnimals.isEmpty && isLoading == false) { view in
            view.emptyState(.cat, action: removeFilter, content: {
                if !filter.isEmpty {
                    FilterView(filter: $filter)
                        .padding(.bottom, Padding.medium.rawValue)
                }
            })
        }
    }
    
    var missing: some View {
        VStack {
            
        }.emptyState(.search)
    }
    
    private func removeFilter() {
        for value in filter.values() {
            withAnimation(.bouncy) {
                filter.remove(value: value)
            }
        }
    }
    
    @MainActor
    private func fetchAllAnimals() async {
        isLoading = true
        do {
            // Busca apenas da ong quatro patas
            let ongId = "7IicBiq4WcVD6VG5N6V32wPsE5Y2"
            var allAnimals: [Animal] = []
            
            let animals: [Animal] = try await databaseProvider.fetch(from: "users/\(ongId)/animals") {
                $0.whereField("isAdopted", isEqualTo: false)
                    .order(by: "position", descending: false)
            }
            allAnimals.append(contentsOf: animals)
            
            withAnimation(.spring()) {
                self.animals = allAnimals
            }
            self.isLoading = false
            
            isLoading = false
        } catch {
            toast(error.localizedDescription, .error)
            isLoading = false
        }
    }
    
}
