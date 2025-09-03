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
    @State private var images: [String] = []
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false
    
    @State private var name = ""
    @State private var age = ""
    @State private var gender: String? = nil
    @State private var type: String? = nil
    
    @State private var breed = ""
    @State private var color = ""
    @State private var size = ""
    @State private var description = ""
    
    
    @Environment(\.toast) var toast
    @EnvironmentObject var navigator: Navigator
    
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
                        navigator.dismiss()
                        toast("animal adicionado com sucesso!", .success)
                    } else {
                        toast("Preencha todos os campos obrigatórios!", .error)
                    }
                }) {
                    Text("Cadastrar")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                .padding(.top, Padding.medium.rawValue)
            }
        }
        .navigationTitle("Cadastrar Animal")
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { newValue, nextValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data),
                   let path = saveImageToTemp(uiImage) {
                    images.append(path.absoluteString)
                    selectedImageIndex = images.count - 1
                }
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
        if name.isEmpty || age.isEmpty || gender == nil || type == nil ||
            breed.isEmpty || color.isEmpty || size.isEmpty || description.isEmpty || images.isEmpty {
            return false
        }
        return true
    }
}

