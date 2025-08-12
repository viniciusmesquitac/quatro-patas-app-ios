//
//  AnimalsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct AnimalsView: View {
    private let collumns = Array(repeating: GridItem(.flexible(minimum: 170, maximum: 170)), count: 2)
    private let navigationTitle: String = "Animais"
    
    @State private var animals = AnimalMock.animals
    @State private var filter: AnimalFilter? = nil
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: collumns, spacing: Padding.xLarge.rawValue) {
                ForEach(animals, id: \.id) { animal in
                    AnimalCardView(animal: animal)
                        .onTapGesture {
                            navigator.navigate(to: .details(animal))
                        }
                }
            }
        }.refreshable {
            await refresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    navigator.present(sheet: .animalFilter(animals, filter ?? AnimalFilter())) { data in
                        let data = data as? [String: Any] ?? [:]
                        self.animals = data["animals"] as? [Animal] ?? []
                        self.filter = data["filter"] as? AnimalFilter
                    }
                }) {
                    SFIcons.image(.filter)
                }
            }
        }
        .navigationTitle(navigationTitle)
    }
    
    func refresh() async {
         do {
             try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
             animals = AnimalMock.animals
             filter = nil
         } catch {
             
         }
     }
}
