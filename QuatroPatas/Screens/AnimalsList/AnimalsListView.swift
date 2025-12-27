//
//  AdoptionListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import SwiftUI

enum AnimalListType {
    case ongAnimals
    case myAnimals
}

struct AnimalsListView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    
    @State private var animals: [Animal] = []
    @State private var isLoading: Bool = false
    @State private var searchText: String = ""
    
    var listType: AnimalListType
    
    var navigationBarTitle: String {
        switch listType {
        case .ongAnimals:
            return "Animais"
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
        ScrollView {
            LazyVStack(spacing: Padding.medium.rawValue) {
                ForEach(filteredAnimals, id: \.id) { animal in
                    AnimalCardViewRow(animal: animal) {
                        switch listType {
                        case .myAnimals:
                            didSelectMyAnimal(animal: animal)
                        case .ongAnimals:
                            didSelectMyAnimal(animal: animal)
                        }
                    }
                    .padding(.horizontal, Padding.medium.rawValue)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .transition(.opacity)
                        .padding(.top, Padding.large.rawValue)
                }
            }.padding(Padding.medium.rawValue)
        }
        .if(filteredAnimals.isEmpty && !isLoading ) { view in
            view.emptyState(.cat, action: addAnimal)
        }
        .if(animals.count >= 10) { view in
            view.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar animal pelo nome")
        }
        .task {
            await fetchAllAnimals()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationBarTitle)
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbarItem(icon: .add, placement: .topBarTrailing) {
            addAnimal()
        }
    }
    
    func addAnimal() {
        navigator.navigate(to: .addAnimal)
    }
    
    @MainActor
    func fetchAllAnimals() async {
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

    func didSelectMyAnimal(animal: Animal) {
        navigator.navigate(to: .animalWallet(animal.localized))
    }

}
