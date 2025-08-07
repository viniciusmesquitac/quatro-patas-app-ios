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
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: collumns, spacing: Padding.xLarge.rawValue) {
                ForEach(AnimalMock.animals, id: \.id) { animal in
                    AnimalCardView(animal: animal)
                        .onTapGesture {
                            navigator.navigate(to: .details(animal)) { data in
                                let animal = data as? Animal
                                print("dismissed \(animal?.name ?? "none")")
                            }
                        }
                }
            }
        }.refreshable {
            await refresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    navigator.present(sheet: .filter)
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
         } catch {
             
         }
     }
}
