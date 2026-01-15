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
    
    @State private var selectedFolder: String = "Todos"
    @State private var reloadAnimals: Bool = false

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
        animals.filter { animal in
            let matchesSearch =
                searchText.isEmpty ||
                animal.name.localizedCaseInsensitiveContains(searchText)

            let matchesFolder =
                selectedFolder.lowercased() == "todos" ||
                animal.folder == selectedFolder

            return matchesSearch && matchesFolder
        }
    }
    
    var folders: [String] {
        Array(
            Set(animals.compactMap { $0.folder })
        ).sorted()
    }
    
    var body: some View {
        ScrollView {
            if !folders.isEmpty {
                Picker("Segment", selection: $selectedFolder) {
                    ForEach(["Todos"] + folders, id: \.self) { folder in
                        Text(folder)
                    }
                }
                .padding(Padding.medium.rawValue)
                .pickerStyle(.segmented)
            }
            LazyVStack(spacing: Padding.medium.rawValue) {
                ForEach(filteredAnimals, id: \.id) { animal in
                    AnimalCardViewRow(animal: animal, action: {
                        switch listType {
                        case .myAnimals:
                            didSelectMyAnimal(animal: animal)
                        case .ongAnimals:
                            didSelectMyAnimal(animal: animal)
                        }
                    })
                    .if(selectedFolder != "Todos", transform: { view in
                        view.contextMenu(menuItems: {
                            Button("Remover da Pasta") {
                                Task {
                                    await removeFromFolder(animal: animal)
                                    reloadAnimals.toggle()
                                }
                            }
                        })
                    })
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
        .onChange(of: reloadAnimals) {
            Task {
                await fetchAllAnimals()
            }
        }
        .onChange(of: filteredAnimals) {
            if filteredAnimals.isEmpty {
                selectedFolder = "Todos"
            }
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
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(String(), systemImage: SFIcon.addFolder.rawValue) {
                    addFolder()
                }
                Button(String(), systemImage: SFIcon.add.rawValue) {
                    addAnimal()
                }
            } label: {
                SFIcon.image(.add)
            }
        }
    }
    
    func addAnimal() {
        navigator.navigate(to: .addAnimal)
    }
    
    func addFolder() {
        navigator.present(sheet: .addFolder(reload: $reloadAnimals))
    }
    
    func removeFromFolder(animal: Animal) async {
        do {
            guard let path = animalPathBuilder(), let animalId = animal.id else {
                throw EditAnimalError.pathError
            }
            _ = try await databaseProvider.deleteField(
                in: path,
                id: animalId,
                field: "folder"
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func animalPathBuilder() -> String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals"
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
