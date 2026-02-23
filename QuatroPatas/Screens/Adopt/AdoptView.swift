//
//  AdoptView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 30/09/25.
//

import SwiftUI

struct AdoptView: View {
    
    @State private var filter = AnimalFilter()
    @State var animals: [Animal] = []
    @EnvironmentObject var navigator: Navigator
    @State private var location: String = String()
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    var body: some View {
        ScrollView {
            FilterSelectorView(animals: $animals, filter: $filter, location: $location)
            AnimalsAvailableView(filter: $filter, location: $location, animals: $animals)
            
            if filteredAnimals.isEmpty {
                buildEmptyStateView()
            }
        }
        .toolbarItem(label: location.isEmpty ? "Mudar região" : location, placement: .topBarLeading) {
            navigator.present(sheet: .selectCityState(location: $location))
        }
        .navigationTitle("Adoção")
    }
    
    @ViewBuilder
    func buildEmptyStateView() -> some View {
        ContentUnavailableView {
            Spacer()
            LottieView(name: "empty_search", loopMode: .loop)
                .frame(width: 200, height: 200)
        } description: {
            Text("Não encontramos ninguém com essas características.")
                .font(.footnote)
        } actions: {
            Button("Buscar todos os animais") {
                filter.removeAll()
                location = String()
            }
        }
    }
    
}

