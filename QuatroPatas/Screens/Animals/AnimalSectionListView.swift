//
//  AnimalSectionListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/09/25.
//

import SwiftUI

struct AnimalSectionListView: View {

    @State var animals: [Animal]
    @State private var filter = AnimalFilter()

    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @Environment(\.toast) var toast

    @State private var isLoading = false

    private let columns = Array(repeating: GridItem(.flexible(minimum: 170, maximum: 170)), count: 2)

    var body: some View {
        ZStack {
            ScrollView() {
                FilterView(filter: $filter)
                LazyVGrid(columns: columns, spacing: Padding.xLarge.rawValue) {
                    ForEach(filteredAnimals, id: \.id) { animal in
                        AnimalCardView(animal: animal) {
                            navigator.navigate(to: .details(animal))
                        }
                    }
                }

                if filteredAnimals.isEmpty && isLoading == false {
                    buildEmptyStateView()
                }
            }

            if isLoading {
                LoadingDotsView()
            }
        }
        .refreshable {
            await refresh()
        }
        .toolbarItem(icon: .filter, action: {
            navigator.present(sheet: .animalFilter(animals, $filter))
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(!isLoading ? "Resultado(\(filteredAnimals.count))" : String())
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbar(.hidden, for: .tabBar)
    }

    
    
    @ViewBuilder
    func buildEmptyStateView() -> some View {
        ContentUnavailableView {
            Spacer()
            Image("empty-state-animals")
                .resizable()
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
             await fetchAllAnimals()
             filter = AnimalFilter()
             isLoading = false
         }
     }
    
    @MainActor
    func fetchAllAnimals() async {
        do {
            let items: [Animal] = try await databaseProvider.fetch(from: "animals")
            self.animals = items
            isLoading = false
        } catch {
            toast(error.localizedDescription, .error)
            isLoading = false
        }
    }
}
