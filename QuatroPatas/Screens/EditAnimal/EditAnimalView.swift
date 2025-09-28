//
//  EditAnimalView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/09/25.
//

import SwiftUI
import PhotosUI

struct EditAnimalView: View {

    @State private var images: [URL] = []

    @State private var uploadedURLs: [String] = []
    @State private var isLoading = false

    @State public var animal: Animal
    @State private var originalAnimal: Animal
    
    @Environment(\.toast) var toast
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    @EnvironmentObject var firebaseStorageProvider: FirebaseStorageProvider
    @EnvironmentObject var userSession: UserSession

    @State var years: Int = 0
    @State var months: Int = 0
    
    init(animal: Animal) {
        _animal = State(initialValue: animal)
        _originalAnimal = State(initialValue: animal)
    }
    
    var hasChanges: Bool {
        animal != originalAnimal || !images.isEmpty
    }

    var filteredBreeds: [String] {
        guard let type = AnimalType.fromLocalized(animal.type) else {
            return [Breed.localized(.mixed)]
        }
        return Breed.localizedByType(type)
    }
    
    var filteredTags: [String] {
        guard let type = AnimalType.fromLocalized(animal.type) else {
            return [AnimalTag.localized(.neutered), AnimalTag.localized(.vaccinated)]
        }
        return AnimalTag.localizedByType(type)
    }

    var formElements: [FormElement] {
        [
            .textField(title: "Nome", placeholder: "Digite o nome", binding: $animal.name),
            .agePicker(years: $years, months: $months),
            .selectable(title: "Gênero", options: Gender.allLocalized, binding: $animal.gender),
            .selectable(title: "Tipo", options: AnimalType.allLocalized, binding: $animal.type),
            .dropdown(title: "Raça", options: filteredBreeds, binding: $animal.breed),
            .dropdown(title: "Cor", options: AnimalColor.allLocalized, binding: $animal.color),
            .dropdown(title: "Tamanho", options: AnimalSize.allLocalized, binding: $animal.size),
            .multiselection(title: "Caracteristicas", options: filteredTags, binding: $animal.tags),
            .textEditor(title: "Descrição", binding: $animal)
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.medium.rawValue) {
                ImagesGrid(
                    existingPhotos: $animal.photos,
                    newImages: $images,
                    maxPhotos: 4
                ).padding()
                
                DynamicFormView(elements: formElements)
                    .padding(.horizontal, Padding.xxLarge.rawValue)
                
                
                HStack {
                    Button("Deletar") {
                        navigator.present(sheet: .deleteAnimal(animal, onDelete: { state in
                            switch state {
                            case .startLoading:
                                isLoading = true
                            case .finished(_):
                                isLoading = false
                            }
                           
                        }))
                    }
                    .buttonStyle(OutlineRoundedButtonStyle())
                    .padding(.leading, Padding.xxLarge.rawValue)

                    Spacer()
                    Button("Salvar") {
                        editAnimal()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.trailing, Padding.xxLarge.rawValue)
                }.padding(.vertical, Padding.medium.rawValue)

            }
        }
        .navigationTitle("Editar")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .if(hasChanges) { view in
            view.toolbarItem(label: "Salvar", placement: .topBarTrailing, action: {
                editAnimal()
            })
        }
        .onAppear {
            if let (y, m) = AgeHelper.toAgeComponents(from: animal.age) {
                years = y
                months = m
            }
        }
        .onChange(of: animal.type) { _, _ in
            animal.breed = ""
            animal.tags.removeAll()
        }
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
        .navigationBarHidden(isLoading)
    }
    
    func uploadImage(imageURL: URL) async throws {
        let data = try Data(contentsOf: imageURL)
        if let uiImage = UIImage(data: data) {
            let resized = uiImage.resized(toMax: 1024)
            if let compressedData = resized.jpegData(compressionQuality: 0.5), let id = animal.id {
                let fileName = "animals/\(id)/\(UUID().uuidString).jpg"
                let url = try await firebaseStorageProvider.uploadFile(data: compressedData, path: fileName)
                uploadedURLs.append(url.absoluteString)
            }
        }
    }
    
    func validateFields(of animal: Animal) -> Bool {
        let mirror = Mirror(reflecting: animal)

        for (_, value) in mirror.children {
            if let str = value as? String {
                if str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return false
                }
            }
        }
        return true
    }

    func editAnimal() {
        animal.age = AgeHelper.calculateAgeTimestamp(years: years, months: months)
        if validateFields(of: animal) {
            isLoading = true
            
            Task {
                do {
                    for imageURL in images {
                        try await uploadImage(imageURL: imageURL)
                    }
                    var copy = animal.deslocalized

                    // 👉 mantém as fotos existentes e adiciona as novas
                    copy.photos = animal.photos + uploadedURLs
                    
                    guard let path = animalPathBuilder() else {
                        throw EditAnimalError.pathError
                    }
                    _ = try await firestoreProvider.update(copy, in: path, withID: animal.id!)
                    toast("Animal editado com sucesso!", .success)
                    isLoading = false
                    navigator.dismiss()
                    navigator.dismiss()
                } catch {
                    toast("Erro ao salvar!", .error)
                    isLoading = false
                }
            }
        } else {
            toast("Preencha todos os campos obrigatórios!", .error)
        }
    }
    
    func animalPathBuilder() -> String? {
        let userId = userSession.user?.id ?? ""
        return "users/\(userId)/animals"
    }
}

