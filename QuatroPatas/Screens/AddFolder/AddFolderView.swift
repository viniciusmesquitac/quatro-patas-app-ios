//
//  AddFolderView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/01/26.
//

import SwiftUI

struct AddFolderView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession

    @State var folderName: String = ""
    @State var disabled: Bool = true

    @State var isPresented: Bool = false
    @State var isLoading: Bool = false
    @State var includedAnimals: [Animal] = []
    
    @Binding var reload: Int

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.medium.rawValue) {
                    TextField("Digite o nome da pasta", text: $folderName)
                        .textFieldStyle(PrimaryTextFieldStyle())
                    Button("Incluir Animais", systemImage: SFIcon.add.rawValue) {
                        isPresented = true
                    }.buttonStyle(OutlineRoundedButtonStyle())
                }.padding(.horizontal, Padding.large.rawValue)
                
                if !includedAnimals.isEmpty {
                    LazyVStack(spacing: Padding.medium.rawValue) {
                        ForEach(includedAnimals, id: \.id) { animal in
                            AnimalCardViewRow(animal: animal, action: nil)
                        }
                        if isLoading {
                            LoadingView()
                        }
                    }.padding(Padding.medium.rawValue)
                }
            }
            .onChange(of: folderName) {
                disabled = folderName.isEmpty || includedAnimals.isEmpty
            }
            .onChange(of: includedAnimals) {
                disabled = folderName.isEmpty || includedAnimals.isEmpty
            }
            .navigationTitle("Nova Pasta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarItem(icon: .checkmark, disabled: $disabled, placement: .confirmationAction) {
                Task {
                    isLoading = true
                    await saveFolderAndAnimals()
                }
            }
            .toolbarItem(icon: .close, placement: .cancellationAction) {
                navigator.dismiss()
            }
            .sheet(isPresented: $isPresented) {
                IncludeAnimalsView(includedAnimals: $includedAnimals, isPresented: $isPresented)
            }
        }
    }
    func saveFolderAndAnimals() async {
        guard let userId = userSession.user?.id else { return }
        do {
            let newFolder = AnimalFolder(name: folderName, createdAt: Date())
            let folderId = try await databaseProvider.add(newFolder, to: "users/\(userId)/folders")

            for animal in includedAnimals {
                try await addFolderToAnimal(animal: animal, folderId: folderId)
            }

            isLoading = false
            reload += 1
            navigator.dismiss()
        } catch {
            print(error.localizedDescription)
            isLoading = false
        }
    }

    func addFolderToAnimal(animal: Animal, folderId: String) async throws {
        guard let path = animalPathBuilder(), let animalId = animal.id else {
            throw EditAnimalError.pathError
        }
        _ = try await databaseProvider.updateFields(
            in: path,
            id: animalId,
            fields: ["folder": folderId]
        )
    }
    
    func animalPathBuilder() -> String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals"
    }
}
