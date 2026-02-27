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
    @State private var isLoading: Bool = false
    
    var filteredAnimals: [Animal] {
        filter.apply(to: animals)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Adoção")
                    .padding(.horizontal, Padding.large.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 24, weight: .bold))
            }
            FilterSelectorView(animals: $animals, filter: $filter, location: $location)
            AnimalsAvailableView(filter: $filter, location: $location, animals: $animals, isLoading: $isLoading)
            
            if filteredAnimals.isEmpty && !isLoading {
                buildEmptyStateView()
            }
        }
        .toolbarBackground(.clear, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                LocationSelectorView(title: location.isEmpty ? "Mudar região" : location) {
                    navigator.present(sheet: .selectCityState(location: $location))
                }
                .tint(Color.primary)
            }
        }
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

