//
//  FavoritesListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 29/09/25.
//


import SwiftUI
import FirebaseStorage

struct FavoritesListView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    
    @State private var animals: [Animal] = []
    @State private var isLoading: Bool = false
    
    let repository = FavoritesRepository()
    
    var navigationBarTitle: String {
        return "Meus Favoritos"
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: Padding.medium.rawValue) {
                    ForEach(animals, id: \.id) { animal in
                        AnimalCardViewRow(animal: animal) {
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
        .onAppear {
            Storage.storage().reference().child("test.txt").putData("test".data(using: .utf8)!)
        }
        .task {
            await fetchAllAnimals()
            filterFavoriteAnimals()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationBarTitle)
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
    }
    
    
    @ViewBuilder
    func buildEmptyStateView() -> some View {
        ContentUnavailableView {
            Spacer()
            LottieView(name: "empty_search", loopMode: .loop)
                .frame(width: 200, height: 200)
        } description: {
            Text("Você ainda não adicionou ninguém aos favoritos")
                .font(.footnote)
        } actions: {
            Button("Buscar Animais") {
                withAnimation {
                    navigator.popToRoot()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigator.selectTab(.animals)
                    }
                }
            }
        }
    }
    
    @MainActor
    func fetchAllAnimals() async {
        do {
            isLoading = true
            let ongId = "rlt2rPJZOveXgqLs54o6lVrufC32"
            var allAnimals: [Animal] = []

            let animals: [Animal] = try await databaseProvider.fetch(from: "users/\(ongId)/animals") {
                $0.whereField("isAdopted", isEqualTo: false)
             }
            allAnimals.append(contentsOf: animals)
            self.animals = allAnimals
            isLoading = false
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }
    
    
    func filterFavoriteAnimals() {
        let animalsIds: [String] = repository.getFavorites()
        self.animals = animals.filter { animalsIds.contains($0.id ?? String()) }
    }
    
    func didSelectFavoriteAnimal(animal: Animal) {
        navigator.navigate(to: .details(animal.localized))
    }
}
