//
//  FilterSelectorView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 23/02/26.
//

import SwiftUI

struct FilterSelectorView: View {
    
    @Binding var animals: [Animal]
    @Binding var filter: AnimalFilter
    @Binding var location: String
    @EnvironmentObject var navigator: Navigator
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }

    var body: some View {
        HStack {
            Text("\(filteredAnimals.count) resultados")
                .font(.system(size: 17))
                .padding(.trailing, 4)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button {
                navigator.present(sheet: .animalFilter(animals, $filter))
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Filtrar animais")
                        .font(.system(size: 17, weight: .medium))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
