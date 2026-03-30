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
    @State private var animalFolders: [AnimalFolder] = []
    @State private var isLoading: Bool = false
    @State private var searchText: String = ""
    
    @State private var selectedFolderId: String? = nil
    @State private var reloadAnimals = 0

    @Environment(\.toast) var toast
    
    private let allFoldersTitle = "Todos"
    
    var filteredAnimals: [Animal] {
        animals.filter { animal in
            let matchesSearch =
                searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                animal.name.localizedCaseInsensitiveContains(searchText.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let matchesFolder: Bool = {
                guard let selectedFolderId else {
                    return true
                }
                
                guard let animalFolderId = animal.folder, !animalFolderId.isEmpty else {
                    return false
                }
                
                return animalFolderId == selectedFolderId
            }()
            
            return matchesSearch && matchesFolder
        }
    }
    
    var folders: [AnimalFolder] {
        animalFolders.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var selectedFolderTitle: String {
        guard
            let selectedFolderId,
            let folder = folders.first(where: { $0.id == selectedFolderId })
        else {
            return allFoldersTitle
        }
        
        return folder.name
    }
    
    var body: some View {
        ScrollView {
            VStack {
                foldersSection
                animalsSection
            }
        }
        .if(filteredAnimals.isEmpty && !isLoading) { view in
            view.emptyState(.cat, action: addAnimal)
        }
        .if(animals.count >= 10) { view in
            view.searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Buscar animal pelo nome"
            )
        }
        .onChange(of: reloadAnimals) {
            Task {
                await fetchAllAnimals()
            }
        }
        .onChange(of: animalFolders) { _, newFolders in
            guard let selectedFolderId else { return }
            
            let folderStillExists = newFolders.contains { $0.id == selectedFolderId }
            if !folderStillExists {
                self.selectedFolderId = nil
            }
        }
        .task {
            if userSession.isLoggedIn {
                await fetchAllAnimals()
            }
        }
        .disabled(isLoading)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Meus Animais")
        .toolbar {
            toolbarContent
        }
    }
    
    private var foldersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if !folders.isEmpty {
                    folderChip(title: allFoldersTitle, isSelected: selectedFolderId == nil) {
                        selectedFolderId = nil
                    }

                    ForEach(folders, id: \.id) { folder in
                        folderChip(
                            title: folder.name,
                            isSelected: selectedFolderId == folder.id
                        ) {
                            guard let id = folder.id else { return }
                            selectedFolderId = id
                        }
                    }
                }

                addFolderChip
            }
            .padding(.horizontal, Padding.medium.rawValue)
            .padding(.top, Padding.medium.rawValue)
        }
    }

    private var addFolderChip: some View {
        Button(action: addFolder) {
            HStack(spacing: 4) {
                Image(systemName: SFIcon.addFolder.rawValue)
                    .font(.system(size: 12))
                Text("Nova Pasta")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(Color.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.15))
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
    
    private func folderChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primaryColor : Color.gray.opacity(0.15))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
    
    private var animalsSection: some View {
        LazyVStack(spacing: Padding.medium.rawValue) {
            ForEach(filteredAnimals, id: \.id) { animal in
                animalRow(animal)
            }
            
            if isLoading {
                LoadingView()
            }
        }
        .padding(Padding.medium.rawValue)
    }
    
    @ViewBuilder
    private func animalRow(_ animal: Animal) -> some View {
        if selectedFolderId == nil {
            baseAnimalRow(animal)
                .contextMenu {
                    addToFolderMenu(animal)
                }
        } else {
            baseAnimalRow(animal)
                .contextMenu {
                    removeFromFolderMenu(animal)
                }
        }
    }
    
    private func baseAnimalRow(_ animal: Animal) -> some View {
        AnimalCardViewRow(animal: animal) {
            didSelectMyAnimal(animal: animal)
        }
        .allowsHitTesting(!isLoading)
        .padding(.horizontal, Padding.medium.rawValue)
    }
    
    @ViewBuilder
    private func addToFolderMenu(_ animal: Animal) -> some View {
        Text("Adicionar à pasta")
            .font(.headline)
            .foregroundColor(.secondary)
        
        Divider()
        
        ForEach(folders, id: \.id) { folder in
            Button(folder.name) {
                Task {
                    guard let folderId = folder.id else { return }
                    await includeAnimalToFolder(
                        animal: animal,
                        folderId: folderId,
                        folderName: folder.name
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private func removeFromFolderMenu(_ animal: Animal) -> some View {
        Button("Remover da Pasta") {
            Task {
                await removeFromFolder(animal: animal)
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(String(), systemImage: SFIcon.add.rawValue) {
                addAnimal()
            }
        }
    }
    
    func addAnimal() {
        navigator.navigate(to: .addAnimal)
    }
    
    func addFolder() {
        navigator.present(sheet: .addFolder(reload: $reloadAnimals))
    }

    func includeAnimalToFolder(animal: Animal, folderId: String, folderName: String) async {
        do {
            guard let path = animalPathBuilder(), let animalId = animal.id else {
                throw EditAnimalError.pathError
            }
            
            isLoading = true
            
            _ = try await databaseProvider.updateFields(
                in: path,
                id: animalId,
                fields: ["folder": folderId]
            )
            
            toast("\(animal.name) adicionado à pasta: \(folderName)", .success)
            await fetchAllAnimals()
        } catch {
            isLoading = false
            print(error.localizedDescription)
        }
    }
    
    func removeFromFolder(animal: Animal) async {
        do {
            guard let path = animalPathBuilder(), let animalId = animal.id else {
                throw EditAnimalError.pathError
            }
            
            isLoading = true
            
            _ = try await databaseProvider.deleteField(
                in: path,
                id: animalId,
                field: "folder"
            )
            
            toast("\(animal.name) removido da pasta!", .success)
            await fetchAllAnimals()
        } catch {
            isLoading = false
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
            
            guard let userId = userSession.user?.id else {
                isLoading = false
                return
            }
            
            let animalItems: [Animal] = try await databaseProvider.fetch(from: "users/\(userId)/animals")
            let folderItems: [AnimalFolder] = try await databaseProvider.fetch(from: "users/\(userId)/folders")
            
            self.animals = animalItems
            self.animalFolders = folderItems
            
            if let selectedFolderId,
               !folderItems.contains(where: { $0.id == selectedFolderId }) {
                self.selectedFolderId = nil
            }
            
            isLoading = false
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
            isLoading = false
        }
    }

    func didSelectMyAnimal(animal: Animal) {
        navigator.navigate(to: .animalWallet(animal.localized))
    }
}
