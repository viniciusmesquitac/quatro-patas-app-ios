//
//  AdoptionListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import SwiftUI

struct AnimalsListView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider

    @State private var animals: [Animal] = []
    
    private let collumns = Array(repeating: GridItem(.flexible(minimum: 170, maximum: 170)), count: 1)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: collumns, spacing: Padding.xLarge.rawValue) {
                ForEach(animals, id: \.id) { animal in
                    AnimalCardView(animal: animal) {
                        navigator.navigate(to: .details(animal))
                    }
                }
            }
    
            if animals.isEmpty {
                buildEmptyStateView()
            }
    
//            if isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .transition(.opacity)
//            }
        }.task {
//            await fetchAllAnimals()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Meus Animais")
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) { navigator.dismiss() }
        .toolbarItem(icon: .add, placement: .topBarTrailing) { navigator.navigate(to: .addAnimal)}
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
        } actions: { }
    }
    
    
    @MainActor
    func fetchAllAnimals() async {
        do {
            let items: [Animal] = try await databaseProvider.fetch(from: "animals")
            self.animals = items
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }
    
}
