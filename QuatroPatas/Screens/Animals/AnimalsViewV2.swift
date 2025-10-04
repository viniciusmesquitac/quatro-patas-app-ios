//
//  AnimalsViewV2.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct AnimalsViewV2: View {

    @State private var animals: [Animal] = []

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @Environment(\.toast) var toast

    @State private var isLoading = true

    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Text("Animais")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, Padding.xxLarge.rawValue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
            
                if isLoading == false {
                    Spacer()
                    AnimalsHorizontalSection(
                        title: "Disponiveis para adoção",
                        animals: Array(animals.prefix(7))
                    ) { animal in
                        navigator.navigate(to: .details(animal))
                    } onAcessoryItem: {
                        navigator.navigate(to: .seeAllAnimals(animals))
                    }
                }

                if animals.isEmpty && isLoading == false {
                    buildEmptyStateView()
                }
            }

            if isLoading {
                LoadingDotsView()
                Spacer()
            }
        }
        .background(Color.primaryBackground)
        .task {
            await fetchAllAnimals()
        }
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
