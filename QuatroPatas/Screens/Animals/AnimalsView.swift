//
//  AnimalsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

struct AnimalsView: View {

    @State private var animals: [Animal] = []
    @State private var filter = AnimalFilter()

    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @Environment(\.toast) var toast

    @State private var isLoading = true

    private let columns = [
        GridItem(.adaptive(minimum: 170), spacing: Spacing.medium.rawValue)
    ]

    var body: some View {
        ZStack {
            ScrollView() {
                FilterView(filter: $filter)
                LazyVGrid(columns: columns, spacing: Padding.xLarge.rawValue) {
                    ForEach(filteredAnimals, id: \.id) { animal in
                        AnimalCardView(animal: animal) {
                            navigator.navigate(to: .details(animal))
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                }.padding(.horizontal, Padding.large.rawValue)

                if filteredAnimals.isEmpty && isLoading == false {
                    buildEmptyStateView()
                }
            }
        }.refreshable {
            await refresh()
        }
        .task {
            await fetchAllAnimals()
        }
        .toolbarItem(icon: .filter, action: {
            navigator.present(sheet: .animalFilter(animals, $filter))
        })
        .navigationTitle(AppTab.localized(.animals) + " (\(filteredAnimals.count))")
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
    
    func refresh() async {
         do {
             isLoading = true
             await fetchAllAnimals()
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
            
            isLoading = false
        } catch {
            toast(error.localizedDescription, .error)
            isLoading = false
        }
    }

}
