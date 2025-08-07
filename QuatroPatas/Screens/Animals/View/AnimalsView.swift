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
                            navigator.navigate(to: .details(animal))
                        }
                }
            }
        }.refreshable {
            await waitFiveSeconds()
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
    
    func waitFiveSeconds() async {
         do {
             try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
             print("Atualização após 5 segundos.")
         } catch {
             print("A tarefa de atualização foi cancelada.")
         }
     }
}
