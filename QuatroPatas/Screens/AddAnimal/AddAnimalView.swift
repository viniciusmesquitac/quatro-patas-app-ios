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
    @State private var showPhotoPicker = false
    @State private var isLoading = false
    
    @State private var name = ""
    @State private var age = ""
    @State private var gender = ""
    @State private var type = ""
    
    @State private var breed = ""
    @State private var color = ""
    @State private var size = ""
    @State private var description = ""
    
    
    @Environment(\.toast) var toast
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    @EnvironmentObject var firebaseStorage: FirebaseStorageProvider

    var formElements: [FormElement] {
        [
            .textField(title: "Nome", placeholder: "Digite o nome", binding: $name),
            .textField(title: "Idade", placeholder: "Digite a idade", binding: $age, keyboard: .numberPad),
            .selectable(title: "Gênero", options: [Gender.localized(.male), Gender.localized(.female)], binding: $gender),
            .selectable(title: "Tipo", options: [AnimalType.localized(.cat), AnimalType.localized(.dog)], binding: $type),
            .dropdown(title: "Raça", options: Breed.allLocalized, binding: $breed),
            .dropdown(title: "Cor", options: AnimalColor.allLocalized, binding: $color),
            .dropdown(title: "Tamanho", options: AnimalSize.allLocalized, binding: $size),
            .textEditor(title: "Descrição", binding: $description)
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.medium.rawValue) {
                ZStack {
                    if images.isEmpty {
                        RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 250)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                            .onTapGesture {
                                showPhotoPicker = true
                            }
                    } else {
                        ImageCarousel(
                            images: images,
                            selectedIndex: $selectedImageIndex,
                            frame: CGSize(width: UIScreen.main.bounds.width, height: 250)
                        )
                        .onTapGesture {
                            showPhotoPicker = true
                        }
                    }
                }

                // === FORM ===
                DynamicFormView(elements: formElements)
                    .padding(.horizontal)
                
                // Add button
                Button(action: {
                    if validateFields() {
                        var animal = Animal(
                            name: name,
                            age: age,
                            gender: gender,
                            type: type,
                            breed: breed,
                            color: color,
                            description: description
                        )
                        
                        Task {
                            isLoading = true
                            do {
                                var uploadedURLs: [String] = []
                                
                                for imageURL in images {
                                    let data = try Data(contentsOf: imageURL)
                                    if let uiImage = UIImage(data: data) {
                                        let resized = uiImage.resized(toMax: 1024)
                                        if let compressedData = resized.jpegData(compressionQuality: 0.7) {
                                            let fileName = "animals/\(UUID().uuidString).jpg"
                                            let url = try await firebaseStorage.uploadFile(data: compressedData, path: fileName)
                                            uploadedURLs.append(url.absoluteString)
                                        }
                                    }
                                }
                                
                                animal.photos = uploadedURLs
                                try await firestoreProvider.add(animal, to: "animals")
                                toast("animal adicionado com sucesso!", .success)
                                navigator.dismiss()
                            } catch {
                                toast("erro ao salvar!", .error)
                            }
                            isLoading = false
                        }
                    } else {
                        toast("Preencha todos os campos obrigatórios!", .error)
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Cadastrar")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
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
        .onChange(of: selectedPhotos) { newItems in
            Task {
                var newURLs: [URL] = []
                
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data),
                       let path = saveImageToTemp(uiImage) {
                        newURLs.append(path)
                    }
                }
                
                // sobrescreve mantendo consistência com o que foi selecionado
                images = newURLs
                selectedImageIndex = images.count - 1
            }
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
    
    func validateFields() -> Bool {
        if name.isEmpty || age.isEmpty || gender.isEmpty || type.isEmpty ||
            breed.isEmpty || color.isEmpty || size.isEmpty || description.isEmpty || images.isEmpty {
            return false
        }
        return true
    }
}

