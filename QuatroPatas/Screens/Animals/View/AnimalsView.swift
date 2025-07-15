//
//  AnimalsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct AnimalsView: View {
    private let collumns = Array(repeating: GridItem(.flexible(minimum: 170, maximum: 170)), count: 2)
    private let navigationTitle: String = "Para Adoção"
    private let cardSize: CGSize = CGSize(width: 150, height: 220)

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: collumns, spacing: 24) {
                    ForEach(AnimalMock.animals, id: \.id) { animal in
                        AnimalCardView(animal: animal)
                            .frame(width: cardSize.width, height: cardSize.height)
                    }
                }
            }
            .navigationTitle(navigationTitle)
        }
    }
}
