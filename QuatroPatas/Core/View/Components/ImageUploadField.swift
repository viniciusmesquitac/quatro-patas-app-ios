//
//  ImageUploadField.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/10/25.
//

import SwiftUI
import PhotosUI

struct ImageUploadField: View {
    @Binding var answer: String
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    @State private var uploadProgress: Double = 0
    @State private var uploadedFilePath: String?
    
    let firebaseStorageProvider = FirebaseStorageProvider()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            if let selectedImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    
                    // Botão de remover
                    Button {
                        Task {
                            await deleteImageFromFirebase()
                            withAnimation {
                                self.answer = ""
                                self.selectedImage = nil
                                self.selectedItem = nil
                            }
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .padding(8)
                    }
                }
            }
            
            // Botão para escolher imagem
            PhotosPicker(selection: $selectedItem, matching: .images) {
                HStack {
                    Label(
                        selectedImage == nil ? "Selecionar imagem" : "Trocar imagem",
                        systemImage: selectedImage == nil ? "photo" : "arrow.triangle.2.circlepath"
                    )
                    Spacer()
                    
                    if isUploading {
                        ProgressView(value: uploadProgress)
                            .progressViewStyle(.linear)
                            .frame(maxWidth: 100)
                    }
                }
                .padding(.vertical, 8)
            }
            .disabled(isUploading)
            .opacity(isUploading ? 0.5 : 1)
            
        }
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            Task { await uploadImage(item: newItem) }
        }
        .animation(.easeInOut, value: selectedImage)
    }
    
    // 🔥 Upload no Firebase e mostra preview
    func uploadImage(item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else { return }
            
            await MainActor.run {
                isUploading = true
                selectedImage = uiImage
            }
            
            // Redimensiona e comprime
            let resized = uiImage.resized(toMax: 1024)
            guard let compressedData = resized.jpegData(compressionQuality: 0.5) else {
                await MainActor.run { isUploading = false }
                return
            }
            
            let filePath = "forms/\(UUID().uuidString).jpg"
            
            // Upload
            let url = try await firebaseStorageProvider.uploadFile(data: compressedData, path: filePath, progress: $uploadProgress)
            
            await MainActor.run {
                answer = url.absoluteString
                uploadedFilePath = filePath
                isUploading = false
            }
        } catch {
            print("❌ Erro ao enviar imagem: \(error.localizedDescription)")
            await MainActor.run {
                isUploading = false
            }
        }
    }
    
    // 🗑️ Deleta do Firebase
    func deleteImageFromFirebase() async {
        guard let path = uploadedFilePath else { return }
        do {
            _ = try await firebaseStorageProvider.deleteFile(path: path)
            print("✅ Imagem deletada do Firebase: \(path)")
        } catch {
            print("❌ Erro ao deletar imagem do Firebase: \(error.localizedDescription)")
        }
        uploadedFilePath = nil
    }
}
