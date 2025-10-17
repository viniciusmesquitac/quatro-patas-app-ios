//
//  ReportMissingAnimalView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/10/25.
//

import SwiftUI
import PhotosUI

struct ReportMissingAnimalView: View {
    
    @State private var selectedImageIndex = 0
    @State private var images: [URL] = []
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var uploadedURLs: [String] = []
    @State private var showPhotoPicker = false
    @State private var isLoading = false
    @State private var isLoadingImage = false
    @State private var uploadProgress: Double = 0
    @State private var currentUploadIndex = 0
    
    @State private var animal = Animal.empty
    
    @Environment(\.toast) var toast
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var storageProvider: StorageProvider

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
            .textField(title: "Nome", placeholder: "Digite o nome se souber", binding: $animal.name),
            .selectable(title: "Tipo", options: [AnimalType.localized(.cat), AnimalType.localized(.dog)], binding: $animal.type),
            .selectable(title: "Gênero", options: [Gender.localized(.male), Gender.localized(.female)], binding: $animal.gender),
            .dropdown(title: "Raça", options: filteredBreeds, binding: $animal.breed),
            .locationPicker(title: "Ultimo local visto", binding: $animal.description)
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
                    Text("Enviar")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: isLoading))
                .padding(.horizontal)
                .padding(.top, Padding.medium.rawValue)
                .disabled(isLoading)
            }
        }
        .navigationTitle("Animal Perdido")
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotos,
            maxSelectionCount: 4,
            matching: .images,
            photoLibrary: .shared()
        )
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
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
        .animation(.easeInOut, value: currentUploadIndex)
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
    
    @MainActor
    func uploadImages(forAnimalId id: String) async throws -> [String] {
        var uploadedURLs: [String] = []
        currentUploadIndex = 0
        uploadProgress = 0.0

        guard !images.isEmpty else { return [] }

        let progressPerImage = 1.0 / Double(images.count)
        var throttledProgress: Double = 0
        var lastUpdate = Date()

        for (index, imageURL) in images.enumerated() {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentUploadIndex = index + 1
            }

            do {
                let data = try Data(contentsOf: imageURL)
                guard let uiImage = UIImage(data: data) else { continue }

                let resized = uiImage.resized(toMax: 1024)
                guard let compressedData = resized.jpegData(compressionQuality: 0.5) else { continue }

                let fileName = "missing-animals/\(id)/\(UUID().uuidString).jpg"

                var imageProgress: Double = 0

                let progressBinding = Binding<Double>(
                    get: { imageProgress },
                    set: { newValue in
                        imageProgress = newValue
                        let totalProgress = (Double(index) * progressPerImage) + (newValue * progressPerImage)

                        // ⏳ Debounce manual: só atualiza a cada 30ms
                        let now = Date()
                        if now.timeIntervalSince(lastUpdate) > 0.03 {
                            lastUpdate = now
                            throttledProgress = totalProgress
                            Task { @MainActor in
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    uploadProgress = min(throttledProgress, 1.0)
                                }
                            }
                        }
                    }
                )

                let url = try await storageProvider.uploadFile(
                    data: compressedData,
                    path: fileName
                )

                uploadedURLs.append(url.absoluteString)

            } catch {
                print("Erro ao enviar imagem \(imageURL.lastPathComponent): \(error)")
                throw error
            }
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            uploadProgress = 1.0
        }

        // Espera 0.3s pra mostrar 100%
        try? await Task.sleep(nanoseconds: 300_000_000)

        return uploadedURLs
    }



    
    func validateFields(of animal: Animal) -> Bool {
        if animal.breed == "" || animal.name == "" ||  animal.gender == "" {
            return false
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
                    fileId: id,
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
                    isMissing: true
                )
                
                let path = "missing-animals"
                _ = try await databaseProvider.add(copy, to: path)
                navigator.dismiss()
                toast("Animal cadastrado com sucesso!", .success)
            } catch {
                toast("erro ao salvar!", .error)
                isLoading = false
            }
        }
    }
}

