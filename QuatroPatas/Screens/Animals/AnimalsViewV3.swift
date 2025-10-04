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
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @Environment(\.toast) var toast
    
    @State private var selectedSegment: AnimalsSegment = .available
    
    @State private var isLoading = true
    
    private let columns = [
        GridItem(.adaptive(minimum: 170), spacing: Spacing.medium.rawValue)
    ]
    
    var animalsView: some View {
        VStack {
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
            Button("Ver todos") {
                navigator.navigate(to: .seeAllAnimals(animals))
            }.padding(.vertical, Padding.medium.rawValue)
        }
    }
    
    var body: some View {
        ScrollView {
            CustomSegmentedPicker(
                selection: $selectedSegment,
                primaryColor: .primaryColor
            ).padding()
            
            switch selectedSegment {
            case .available:
                Group {
                    if !filter.isEmpty {
                        FilterView(filter: $filter)
                            .padding(.bottom, 8)
                    }
                    animalsView
                }
            case .lost:
                EmptyView()
                Spacer()
            @unknown default:
                EmptyView()
            }
            
            if filteredAnimals.isEmpty && isLoading == false {
                buildEmptyStateView()
            }
        }
        .refreshable {
            await fetchAllAnimals()
        }
        .onAppear {
            Task {
                await fetchAllAnimals()
            }
        }
        .toolbarItem(icon: .filter, action: {
            navigator.present(sheet: .animalFilter(animals, $filter))
        })
        .navigationTitle("Animais")
    }
    

    @ViewBuilder
    func buildEmptyStateView() -> some View {
        ContentUnavailableView {
            Spacer()
            LottieView(name: "cat_in_box", loopMode: .loop)
                .frame(width: 200, height: 200)
        } description: {
            Text("Hmmm... \nNão tem nada por aqui!")
                .font(.system(size: 24))
        } actions: {
            Button("Buscar todos") {
                for value in filter.values() {
                    withAnimation(.bouncy) {
                        filter.remove(value: value)
                    }
                }
            }
        }
    }
    
    @MainActor
    func fetchAllAnimals() async {
        isLoading = true
        do {
            // Busca apenas da ong quatro patas
            let ongId = "rlt2rPJZOveXgqLs54o6lVrufC32"
            var allAnimals: [Animal] = []
            
            let animals: [Animal] = try await databaseProvider.fetch(from: "users/\(ongId)/animals") {
                $0.whereField("isAdopted", isEqualTo: false)
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

enum AnimalsSegment: String, CaseIterable, Identifiable {
    case available = "Para adoção"
    case lost = "Perdidos"
    
    var id: String { self.rawValue }
}
