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
    @State private var selectedSegment: AnimalsSegment = .available
    @State private var isLoading = true
    @State private var isLoadingMore = false
    @State private var visibleCount = 7
    @State private var showMoreAnimalsCount = 7

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @Environment(\.toast) var toast
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }

    var body: some View {
        ScrollView {
            CustomSegmentedPicker(
                selection: $selectedSegment,
                primaryColor: .primaryColor
            )
            .padding()
            
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
        VStack(spacing: 16) {
            
            // Mostra filtro ativo, se houver
            if !filter.isEmpty {
                FilterView(filter: $filter)
                    .padding(.bottom, Padding.medium.rawValue)
            }

            // Lista de animais visíveis
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
            
            // Botão carregar mais
            if filteredAnimals.count > visibleCount {
                if !filteredAnimals.isEmpty {
                    VStack(spacing: 8) {
                        Text("\(min(visibleCount, filteredAnimals.count)) de \(filteredAnimals.count) animais")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        ProgressView(value: Double(min(visibleCount, filteredAnimals.count)),
                                     total: Double(filteredAnimals.count))
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
        .padding(.bottom, 16)
        .if(filteredAnimals.isEmpty && isLoading == false) { view in
            view.emptyState(.cat, action: removeFilter, content: {
                if !filter.isEmpty {
                    FilterView(filter: $filter)
                        .padding(.bottom, Padding.medium.rawValue)
                }
            })
        }
    }
    
    var missing: some View {
        VStack { }
            .emptyState(.search)
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
            let animals: [Animal] = try await databaseProvider.fetch(from: "users/\(ongId)/animals") {
                $0.whereField("isAdopted", isEqualTo: false)
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
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Simula carregamento
        withAnimation(.spring()) {
            visibleCount = min(visibleCount + showMoreAnimalsCount, filteredAnimals.count)
        }
        isLoadingMore = false
    }
}
