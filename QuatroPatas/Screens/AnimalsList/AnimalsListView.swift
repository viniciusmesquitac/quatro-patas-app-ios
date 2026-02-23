//
//  AdoptionListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import SwiftUI

struct AnimalsListView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    
    @State private var animals: [Animal] = []
    @State private var isLoading: Bool = false
    @State private var searchText: String = ""
    
    @State private var selectedFolder: String = "Todos"
    @State private var reloadAnimals = 0

    @Environment(\.toast) var toast
    
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
                ScrollableSegmentedPicker(
                    items: ["Todos"] + folders,
                    selected: $selectedFolder
                )
                .padding(.top, Padding.medium.rawValue)
            }
            LazyVStack(spacing: Padding.medium.rawValue) {
                ForEach(filteredAnimals, id: \.id) { animal in
                    AnimalCardViewRow(animal: animal, action: {
                        didSelectMyAnimal(animal: animal)
                    })
                    .if(selectedFolder != "Todos", transform: { view in
                        view.contextMenu(menuItems: {
                            Button("Remover da Pasta") {
                                Task {
                                    await removeFromFolder(animal: animal)
                                    reloadAnimals += 1
                                }
                            }
                        })
                    })
                    .padding(.horizontal, Padding.medium.rawValue)
                    
                    .if(selectedFolder == "Todos", transform: { view in
                        view.contextMenu(menuItems: {
                            Text("Adicionar à pasta")
                                   .font(.headline)
                                   .foregroundColor(.secondary)
                               
                            Divider()
                            
                            ForEach(folders, id: \.self) { folder in
                                Button(folder) {
                                    Task {
                                        await includeAnimalToFolder(animal: animal, folderName: folder)
                                    }
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
            if userSession.isLoggedIn {
                await fetchAllAnimals()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Meus Animais")
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

    func includeAnimalToFolder(animal: Animal, folderName: String) async {
        do {
            guard let path = animalPathBuilder(), let animalId = animal.id else {
                throw EditAnimalError.pathError
            }
            _ = try await databaseProvider.updateFields(
                in: path,
                id: animalId,
                fields: ["folder": folderName]
            )
            toast("\(animal.name) adicionado a pasta: \(folderName)", .success)
            reloadAnimals += 1
        } catch {
            print(error.localizedDescription)
        }
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
            reloadAnimals += 1
            toast("\(animal.name) removido da pasta!", .success)
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
            if let userId = userSession.user?.id {
                let items: [Animal] = try await databaseProvider.fetch(from: "users/\(userId)/animals")
                self.animals = items
                
                isLoading = false
            }
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }

    func didSelectMyAnimal(animal: Animal) {
        navigator.navigate(to: .animalWallet(animal.localized))
    }

}
