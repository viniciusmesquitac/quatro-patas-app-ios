//
//  AnimalsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct AnimalsView: View {
    private let collumns = Array(repeating: GridItem(.flexible(minimum: 170, maximum: 170)), count: 2)

    @State private var animals = AnimalMock.animals
    @State private var filter = AnimalFilter()

    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        ScrollView(showsIndicators: false) {
            FilterView(filter: $filter)
            LazyVGrid(columns: collumns, spacing: Padding.xLarge.rawValue) {
                ForEach(filteredAnimals, id: \.id) { animal in
                    AnimalCardView(animal: animal) {
                        navigator.navigate(to: .details(animal))
                    }
                }
            }
    
            if filteredAnimals.isEmpty {
                buildEmptyStateView()
            }
    
        }.refreshable {
            await refresh()
        }
        .toolbarItem(icon: .filter, action: {
            navigator.present(sheet: .animalFilter(animals, $filter))
        })
        .navigationTitle(AppTab.localized(.animals))
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
             try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
             animals = AnimalMock.animals
             filter = AnimalFilter()
         } catch {
             
         }
     }
}
