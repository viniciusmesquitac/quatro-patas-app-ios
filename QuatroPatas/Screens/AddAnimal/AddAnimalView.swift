//
//  AddAnimalView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import SwiftUI
import PhotosUI

struct AddAnimalView: View {
    
    @State private var selectedImageIndex = 0
    @State private var images: [URL] = []
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var uploadedURLs: [String] = []
    @State private var showPhotoPicker = false
    @State private var isLoading = false
    @State private var isLoadingImage = false
    
    @State private var animal = Animal.empty
    
    @Environment(\.toast) var toast
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var firebaseStorageProvider: FirebaseStorageProvider
    
    @State private var years = 0
    @State private var months = 0
    
    
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
            .selectable(title: "Gênero", options: [Gender.localized(.male), Gender.localized(.female)], binding: $animal.gender),
            .selectable(title: "Tipo", options: [AnimalType.localized(.cat), AnimalType.localized(.dog)], binding: $animal.type),
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
                ImageSelectorView(images: images,
                                  selectedIndex: $selectedImageIndex,
                                  showPhotoPicker: $showPhotoPicker,
                                  isLoading: isLoadingImage)
                
                DynamicFormView(elements: formElements)
                    .padding(.horizontal, Padding.xxLarge.rawValue)
                
                Button(action: {
                    addAnimal()
                }) {
                    Text("Cadastrar")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: isLoading))
                .padding(.horizontal)
                .padding(.top, Padding.medium.rawValue)
                .disabled(isLoading)
            }
        }
        .navigationTitle("Cadastrar Animal")
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotos,
            maxSelectionCount: 4,
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
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .onChange(of: animal.type) { _, _ in
            animal.breed = ""
            animal.tags.removeAll()
        }
        .onChange(of: years) {
            animal.age = calculateAgeTimestamp(years: years, months: months)
        }
        .onChange(of: months) {
            animal.age = calculateAgeTimestamp(years: years, months: months)
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
    
    func uploadImages(forAnimalId id: String) async throws -> [String] {
        var uploadedURLs: [String] = []
        
        for imageURL in images {
            do {
                let data = try Data(contentsOf: imageURL)
                if let uiImage = UIImage(data: data) {
                    let resized = uiImage.resized(toMax: 1024)
                    if let compressedData = resized.jpegData(compressionQuality: 0.5) {
                        let fileName = "animals/\(id)/\(UUID().uuidString).jpg"
                        let url = try await firebaseStorageProvider.uploadFile(
                            data: compressedData,
                            path: fileName
                        )
                        uploadedURLs.append(url.absoluteString)
                    }
                }
            } catch {
                print("Erro ao enviar imagem \(imageURL.lastPathComponent): \(error)")
                throw error // interrompe se algum upload falhar
            }
        }
        
        return uploadedURLs
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
    
    func addAnimal() {
        animal.age = calculateAgeTimestamp(years: years, months: months)
        
        // 1️⃣ Primeiro valida se há pelo menos uma foto
        guard !images.isEmpty else {
            toast("Adicione pelo menos uma foto do animal!", .error)
            return
        }

        // 2️⃣ Depois valida os demais campos
        guard validateFields(of: animal) else {
            toast("Preencha todos os campos obrigatórios!", .error)
            return
        }
    
        isLoading = true
        
        Task {
            do {
                let id = UUID().uuidString
                
                // 1️⃣ Faz upload de todas as imagens primeiro
                let uploaded = try await uploadImages(forAnimalId: id)
                
                // 2️⃣ Cria o animal já com as URLs das imagens
                let copy = Animal(
                    id: id,
                    name: animal.name,
                    photos: uploaded,
                    age: animal.age,
                    gender: Gender.fromLocalized(animal.gender)?.caseName ?? "",
                    type: AnimalType.fromLocalized(animal.type)?.caseName ?? "",
                    breed: Breed.fromLocalized(animal.breed)?.caseName ?? "",
                    color: AnimalColor.fromLocalized(animal.color)?.caseName ?? "",
                    size: AnimalSize.fromLocalized(animal.size)?.caseName ?? "",
                    description: animal.description,
                    status: animal.status,
                    tags: animal.tags.compactMap { AnimalTag.fromLocalized($0)?.caseName }
                )
                
                // 3️⃣ Salva no Firestore somente depois que tudo foi enviado
                guard let userId = userSession.user?.id else { return }
                let path = "users/\(userId)/animals"
                _ = try await firestoreProvider.add(copy, to: path)
                navigator.dismiss()
                toast("Animal cadastrado com sucesso!", .success)
            } catch {
                toast("erro ao salvar!", .error)
                isLoading = false
            }
        }
    }
}

