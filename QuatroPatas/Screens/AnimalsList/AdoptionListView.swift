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
    @State private var isLoading: Bool = false
        
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Padding.medium.rawValue) {
                ForEach(animals, id: \.id) { animal in
                    AnimalCardViewRow(animal: animal) {
                        var localizedAnimal = animal
                        localizedAnimal.breed = Breed.localized(Breed(rawValue: animal.breed) ?? .mixed)
                        localizedAnimal.color = AnimalColor.localized(AnimalColor(rawValue: animal.color) ?? .black)
                        localizedAnimal.gender = Gender.localized(Gender(rawValue: animal.gender) ?? .female)
                        localizedAnimal.size = AnimalSize.localized(AnimalSize(rawValue: animal.size) ?? .small)
                        localizedAnimal.type = AnimalType.localized(AnimalType(rawValue: animal.type) ?? .cat)
                        localizedAnimal.tags = animal.tags.compactMap { AnimalTag(rawValue: $0) }.map { AnimalTag.localized($0) }
                        let (years, month) = AgeHelper.toAgeComponents(from: animal.age) ?? (0, 0)
                        navigator.navigate(to: .edit(localizedAnimal, years, month))
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
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Meus Animais")
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbarItem(icon: .add, placement: .topBarTrailing) {
            navigator.navigate(to: .addAnimal)
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
    
}
