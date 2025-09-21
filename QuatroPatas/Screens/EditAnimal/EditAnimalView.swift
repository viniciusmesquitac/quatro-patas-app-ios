//
//  EditAnimalView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/09/25.
//

import SwiftUI
import PhotosUI

struct EditAnimalView: View {

    @State private var selectedImageIndex = 0
    @State private var images: [URL] = []

    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var uploadedURLs: [String] = []
    @State private var showPhotoPicker = false
    @State private var isLoading = false
    @State private var isLoadingImage = false

    @State public var animal: Animal
    
    @Environment(\.toast) var toast
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    @EnvironmentObject var firebaseStorageProvider: FirebaseStorageProvider
    @EnvironmentObject var userSession: UserSession

    @State var years: Int = 0
    @State var months: Int = 0

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
            .textEditor(title: "Descrição", binding: $animal.description)
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.medium.rawValue) {
                AnimalImagesCarousel(
                    existingPhotos: $animal.photos,
                    newImages: $images,
                    selectedPhotos: $selectedPhotos,
                    showPhotoPicker: $showPhotoPicker,
                    selectedIndex: $selectedImageIndex,
                    onRemoveExisting: { index in
                        navigator.present(sheet: .alert(title: "Deseja realmente remover essa imagem?", action: {
                            animal.photos.remove(at: index)
                        }))
                    },
                    onRemoveNew: { index in
                        images.remove(at: index)
                        selectedPhotos.remove(at: index)
                    }
                )

                DynamicFormView(elements: formElements)
                    .padding(.horizontal, Padding.xxLarge.rawValue)
                
                Button(action: {
                    editAnimal()
                }) {
                    Text("Salvar")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: isLoading))
                .padding(.horizontal)
                .padding(.top, Padding.medium.rawValue)
                .disabled(isLoading)
            }
        }
        .navigationTitle("Editar")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .toolbarItem(icon: .delete, color: .red, placement: .topBarTrailing, action: {
            navigator.present(sheet: .deleteAnimal(animal))
        })
        .onAppear {
             if let (y, m) = AgeHelper.toAgeComponents(from: animal.age) {
                 years = y
                 months = m
             }
         }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotos,
            maxSelectionCount: min(4, 4 - (animal.photos.count)),
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhotos) { _, newItems in
            Task {
                isLoadingImage = true
                images.removeAll()
                for item in newItems {
                    await loadImage(from: item)
                }
                selectedImageIndex = max(images.count - 1, 0)
                isLoadingImage = false
            }
        }
        .onChange(of: animal.type) { _, _ in
            animal.breed = ""
            animal.tags.removeAll()
        }
    }
    
    func saveImageToTemp(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return url
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    
    @MainActor
    func loadImage(from item: PhotosPickerItem) async {
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data),
               let path = saveImageToTemp(uiImage) {
                images.append(path)
            }
        } catch {
            print("Erro ao carregar imagem: \(error)")
        }
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

    func calculateAgeTimestamp(years: Int, months: Int) -> String {
        let calendar = Calendar.current
        let now = Date()

        if let date = calendar.date(byAdding: .year, value: -years, to: now),
           let finalDate = calendar.date(byAdding: .month, value: -months, to: date) {
            let timestamp = finalDate.timeIntervalSince1970
            return String(Int(timestamp))
        }
        
        return "0"
    }

    func editAnimal() {
        animal.age = calculateAgeTimestamp(years: years, months: months)
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
        let userType = userSession.user?.type ?? .anonymous
        
        switch userType {
        case .volunteer:
            return "animals"
        case .adopter:
            return "users/\(userId)/animals"
        default:
            return nil
        }
    }
}

