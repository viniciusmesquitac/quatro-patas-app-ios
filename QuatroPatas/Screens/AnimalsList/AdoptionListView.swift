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
    @State private var searchText: String = ""
    
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

    var filteredAnimals: [Animal] {
        if searchText.isEmpty {
            return animals
        } else {
            return animals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
        
    var body: some View {
        VStack {
            HStack {
                SFIcon.image(.search, color: .gray)
                TextField("Buscar animal pelo nome", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(Padding.medium.rawValue)
            .background(Color(.systemGray6))
            .cornerRadius(CornerRadius.medium.rawValue)
            .padding(.horizontal, Padding.medium.rawValue)
            .padding(.top, Padding.medium.rawValue)

            ScrollView {
                LazyVStack(spacing: Padding.medium.rawValue) {
                    ForEach(filteredAnimals, id: \.id) { animal in
                        AnimalCardViewRow(animal: animal) {
                            switch listType {
                            case .myAnimals:
                                didSelectMyAnimal(animal: animal)
                            case .allAnimals:
                                didSelectMyAnimal(animal: animal)
                            case .favorites:
                                didSelectFavoriteAnimal(animal: animal)
                            }
                        }
                        .padding(.horizontal, Padding.medium.rawValue)
                    }
                    
                    if filteredAnimals.isEmpty && !isLoading {
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
            LottieView(name: "cat_in_box", loopMode: .loop)
                .frame(width: 200, height: 200)
        } description: {
            Text("Hmmm... \nNão tem nada por aqui!")
                .font(.footnote)
        } actions: {
            Button("Adicionar Animal") {
                let listToAdd: AddAnimalType  = listType == .allAnimals ? .ongAnimals : .myAnimals
                navigator.navigate(to: .addAnimal(listToAdd))
            }
        }
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
        navigator.navigate(to: .edit(animal.localized))
    }
    
    func didSelectMyAnimal(animal: Animal) {
        navigator.navigate(to: .myAnimalDetails(animal.localized))
    }

    func didSelectFavoriteAnimal(animal: Animal) {
        navigator.navigate(to: .details(animal.localized))
    }
}
