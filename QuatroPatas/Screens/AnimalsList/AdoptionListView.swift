//
//  AdoptionListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import SwiftUI

enum AnimalListType {
    case allAnimals
    case favorites
}

struct AnimalsListView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider

    @State private var animals: [Animal] = []
    @State private var isLoading: Bool = false
    
    var listType: AnimalListType
    let repository = FavoritesRepository()
        
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Padding.medium.rawValue) {
                ForEach(animals, id: \.id) { animal in
                    AnimalCardViewRow(animal: animal) {
                        switch listType {
                        case .allAnimals:
                            didSelectEditAnimal(animal: animal)
                        case .favorites:
                            didSelectFavoriteAnimal(animal: animal)
                        }
                    }
                    .padding(.horizontal, Padding.medium.rawValue)
                }
                
                if animals.isEmpty && !isLoading {
                    buildEmptyStateView()
                        .padding(.top, Padding.large.rawValue)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .transition(.opacity)
                        .padding(.top, Padding.large.rawValue)
                }
            }.padding(Padding.medium.rawValue)
        }
        .task {
            await fetchAllAnimals()
            if listType == .favorites {
                filterFavoriteAnimals()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(listType == .allAnimals ? "Meus Animais": "Animais Favoritos")
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .if(listType == .allAnimals) { view in
            view.toolbarItem(icon: .add, placement: .topBarTrailing) {
                navigator.navigate(to: .addAnimal)
            }
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
        } actions: { }
    }
    
    
    @MainActor
    func fetchAllAnimals() async {
        do {
            isLoading = true
            let items: [Animal] = try await databaseProvider.fetch(from: "animals")
            self.animals = items
            isLoading = false
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }

    func filterFavoriteAnimals() {
        let animalsIds: [String] = repository.getFavorites()
        self.animals = animals.filter { animalsIds.contains($0.id ?? String()) }
    }
    
    func didSelectEditAnimal(animal: Animal) {
        let (years, month) = AgeHelper.toAgeComponents(from: animal.age) ?? (0, 0)
        navigator.navigate(to: .edit(animal.localized, years, month))
    }

    func didSelectFavoriteAnimal(animal: Animal) {
        print("Seleciona animal")
    }

    
}
