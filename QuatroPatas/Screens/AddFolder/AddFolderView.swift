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
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .transition(.opacity)
                                .padding(.top, Padding.large.rawValue)
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
                for animal in includedAnimals {
                    Task {
                        await addFolderToAnimal(animal: animal)
                    }
                }
                navigator.dismiss()
                reload += 1
            }
            .toolbarItem(icon: .close, placement: .cancellationAction) {
                navigator.dismiss()
            }
            .sheet(isPresented: $isPresented) {
                IncludeAnimalsView(includedAnimals: $includedAnimals, isPresented: $isPresented)
            }
        }
    }
    
    func addFolderToAnimal(animal: Animal) async {
        do {
            guard let path = animalPathBuilder(), let animalId = animal.id else {
                throw EditAnimalError.pathError
            }
            _ = try await databaseProvider.updateFields(
                in: path,
                id: animalId,
                fields: ["folder": folderName]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func animalPathBuilder() -> String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals"
    }
}
