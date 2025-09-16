//
//  AdoptionListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import SwiftUI

enum AnimalListType {
    case allAnimals
    case myAnimals
    case favorites
}

struct AnimalsListView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @EnvironmentObject var userSession: UserSession

    @State private var animals: [Animal] = []
    @State private var isLoading: Bool = false
    
    var listType: AnimalListType
    let repository = FavoritesRepository()
    
    var navigationBarTitle: String {
        switch listType {
        case .allAnimals:
            return "Animais da ONG"
        case .favorites:
            return "Meus Favoritos"
        case .myAnimals:
            return "Meus Animais"
        }
    }
        
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Padding.medium.rawValue) {
                ForEach(animals, id: \.id) { animal in
                    AnimalCardViewRow(animal: animal) {
                        switch listType {
                        case .allAnimals, .myAnimals:
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
            switch listType {
            case .allAnimals:
                await fetchAllAnimals()
            case .myAnimals:
                await fetchMyAnimals()
            case .favorites:
                await fetchAllAnimals()
                filterFavoriteAnimals()
            }

        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationBarTitle)
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .if(listType == .allAnimals) { view in
            view.toolbarItem(icon: .add, placement: .topBarTrailing) {
                navigator.navigate(to: .addAnimal(.ongAnimals))
            }
        }
        .if(listType == .myAnimals) { view in
            view.toolbarItem(icon: .add, placement: .topBarTrailing) {
                navigator.navigate(to: .addAnimal(.myAnimals))
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
    
    @MainActor
    func fetchMyAnimals() async {
        do {
            isLoading = true
            let userId = userSession.user?.id ?? ""
            let items: [Animal] = try await databaseProvider.fetch(from: "users/\(userId)/animals")
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
