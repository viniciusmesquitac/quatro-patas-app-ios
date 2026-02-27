//
//  AnimalsAvailableView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 10/10/25.
//

import SwiftUI

struct AnimalsAvailableView: View {
    @Binding var filter: AnimalFilter
    @Binding var location: String
    @Binding var animals: [Animal]

    @Binding var isLoading: Bool
    
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var navigator: Navigator
    @Environment(\.toast) var toast
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }

    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            if !filter.isEmpty {
                FilterView(filter: $filter)
                    .padding(.bottom, Padding.medium.rawValue)
            }

            ForEach(filteredAnimals, id: \.id) { animal in
                AnimalRowView(animal: animal) {
                    navigator.navigate(to: .details(animal))
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
                .padding(.horizontal, Padding.large.rawValue)
            }
        }
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
        .onChange(of: location) { oldValue, newValue in
            Task {
                await fetchNGOs(for: newValue)
            }
        }
        .onAppear {
            Task {
                if animals.isEmpty {
                    await fetchNGOs(for: location)
                } else {
                    isLoading = false
                }
            }
        }
        .padding(.bottom, Padding.large.rawValue)
    }
    
    @MainActor
    private func fetchAllAnimals(ongIds: [String]) async {
        do {
            var allAnimals: [Animal] = []

            for id in ongIds {
                let fetched: [Animal] = try await databaseProvider.fetch(from: "users/\(id)/animals") {
                    $0
                        .whereField("isMissing", isEqualTo: false)
                        .whereField("isAdopted", isEqualTo: false)
                        .order(by: "position", descending: false)
                }
                allAnimals.append(contentsOf: fetched)
            }

            withAnimation(.spring()) {
                self.animals = allAnimals
            }

            isLoading = false
        } catch {
            toast(error.localizedDescription, .error)
            isLoading = false
        }
    }
    
    @MainActor
    private func fetchNGOs(for location: String) async {
        do {
            let items: [User] = try await databaseProvider.fetch(from: "users") { ref in
                var query = ref.whereField("type", isEqualTo: "usertype.ngo")

                if !location.isEmpty {
                    query = query.whereField("location", isEqualTo: location)
                }

                return query
            }

            let ids = items.compactMap { $0.id }
            await fetchAllAnimals(ongIds: ids)

        } catch {
            toast("Erro ao carregar as ONGs", .error)
            print("❌ Fetch error: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    
    private func removeFilter() {
        for value in filter.values() {
            withAnimation(.bouncy) {
                filter.remove(value: value)
            }
        }
        location = ""
    }
}
