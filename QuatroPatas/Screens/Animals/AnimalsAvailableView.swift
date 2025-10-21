//
//  AnimalsAvailableView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 10/10/25.
//

import SwiftUI

struct AnimalsAvailableView: View {
    // MARK: - Properties
    
    @Binding var filter: AnimalFilter
    @Binding var animals: [Animal]

    @State private var isLoading = true
    @State private var isLoadingMore = false
    @State private var visibleCount = 7
    @State private var showMoreAnimalsCount = 7
    
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var navigator: Navigator
    @Environment(\.toast) var toast

    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            if !filter.isEmpty {
                FilterView(filter: $filter)
                    .padding(.bottom, Padding.medium.rawValue)
            }
            
            // Lista de animais
            ForEach(Array(filteredAnimals.prefix(visibleCount)), id: \.id) { animal in
                AnimalRowView(animal: animal) {
                    navigator.navigate(to: .details(animal))
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
                .padding(.horizontal, Padding.large.rawValue)
            }
            
            // Botão "Carregar mais"
            if filteredAnimals.count > visibleCount {
                if !filteredAnimals.isEmpty {
                    VStack(spacing: 8) {
                        Text("\(min(visibleCount, filteredAnimals.count)) de \(filteredAnimals.count) animais")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        ProgressView(
                            value: Double(min(visibleCount, filteredAnimals.count)),
                            total: Double(filteredAnimals.count)
                        )
                        .tint(.primaryColor)
                        .padding(.horizontal, 40)
                    }
                    .transition(.opacity)
                }
                
                Button("Carregar mais") {
                    Task { await loadMoreAnimals() }
                }
                .buttonStyle(TagButtonStyle(isLoading: isLoadingMore))
                .padding(.vertical, Padding.medium.rawValue)
                .padding(.horizontal, Padding.xxLarge.rawValue)
                .animation(.spring(), value: isLoadingMore)
            }
        }
        .onAppear {
            Task {
                await fetchAllAnimals()
            }
        }
        .padding(.bottom, Padding.large.rawValue)
        .if(!filteredAnimals.isEmpty) { view in
            view.toolbarItem(icon: .filter, placement: .topBarTrailing) {
                navigator.present(sheet: .animalFilter(animals, $filter))
            }
        }
        .if(filteredAnimals.isEmpty && isLoading == false) { view in
            view.emptyState(.cat, action: removeFilter, content: {
                if !filter.isEmpty {
                    FilterView(filter: $filter)
                        .padding(.bottom, Padding.medium.rawValue)
                }
            })
        }
    }
    
    @MainActor
    private func fetchAllAnimals() async {
        isLoading = true
        do {
            // Busca apenas da ong quatro patas
            let ongId = "7IicBiq4WcVD6VG5N6V32wPsE5Y2"
            let animals: [Animal] = try await databaseProvider.fetch(from: "users/\(ongId)/animals") {
                $0
                    .whereField("isMissing", isEqualTo: false)
                    .whereField("isAdopted", isEqualTo: false)
                    .order(by: "position", descending: false)
            }
            withAnimation(.spring()) {
                self.animals = animals
                self.visibleCount = min(showMoreAnimalsCount, animals.count)
            }
            isLoading = false
        } catch {
            toast(error.localizedDescription, .error)
            isLoading = false
        }
    }
    
    @MainActor
    private func loadMoreAnimals() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        withAnimation(.spring()) {
            visibleCount = min(visibleCount + showMoreAnimalsCount, filteredAnimals.count)
        }
        isLoadingMore = false
    }
    
    
    private func removeFilter() {
        for value in filter.values() {
            withAnimation(.bouncy) {
                filter.remove(value: value)
            }
        }
    }
}
