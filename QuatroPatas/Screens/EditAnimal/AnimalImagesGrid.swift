//
//  AnimalImagesGrid.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/09/25.
//

import SwiftUI
import PhotosUI

struct ImagesGrid: View {
    @Binding var existingPhotos: [String]
    @Binding var newImages: [URL]

    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var isLoading: [URL?: Bool] = [:]
    @State private var showPhotoPicker = false

    let maxPhotos: Int
    private let columns = [
        GridItem(.adaptive(minimum: 155), spacing: Spacing.medium.rawValue)
    ]

    private var remainingSlots: Int {
        maxPhotos - (existingPhotos.count + newImages.count)
    }

    @EnvironmentObject var navigator: Navigator

    var imageGrid: some View {
        LazyVGrid(columns: columns, spacing: Spacing.xxLarge.rawValue) {
            // Fotos existentes
            ForEach(existingPhotos.indices, id: \.self) { index in
                ExistingPhotoCell(
                    urlString: existingPhotos[index],
                    onRemove: {
                        navigator.present(sheet: .alert(
                            title: "Deseja realmente remover essa imagem?",
                            action: {
                                existingPhotos.remove(at: index)
                                navigator.dismiss()
                            }
                        ))
                    }
                )
            }
            .padding(.horizontal, Padding.large.rawValue)

            // Fotos novas
            ForEach(newImages, id: \.self) { fileURL in
                NewPhotoCell(
                    fileURL: fileURL,
                    isLoading: isLoading[fileURL] ?? false,
                    onRemove: {
                        Task { await onRemoveImage(at: fileURL) }
                    }
                )
            }

            // Slots vazios
            if remainingSlots > 0 {
                ForEach(0..<remainingSlots, id: \.self) { _ in
                    AddPhotoSlot {
                        selectedPhotos.removeAll()
                        showPhotoPicker = true
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isLoading)
    }

    var body: some View {
        VStack {
            imageGrid
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotos,
            maxSelectionCount: remainingSlots,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhotos) { _, newItems in
            Task {
                for item in newItems.prefix(remainingSlots) {
                    let tempURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString + ".jpg")

                    isLoading[tempURL] = true
                    newImages.append(tempURL)

                    if let finalURL = await saveItemToTemp(item) {
                        if let idx = newImages.firstIndex(of: tempURL) {
                            newImages[idx] = finalURL
                            isLoading.removeValue(forKey: tempURL)
                        }
                    } else {
                        newImages.removeAll { $0 == tempURL }
                        isLoading.removeValue(forKey: tempURL)
                    }
                }
            }
        }
    }

    func onRemoveImage(at fileURL: URL) async {
        if let index = newImages.firstIndex(of: fileURL) {
            newImages.remove(at: index)
        }
    }
}

// MARK: - Helpers
private extension ImagesGrid {
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
    func saveItemToTemp(_ item: PhotosPickerItem) async -> URL? {
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                return saveImageToTemp(uiImage)
            }
        } catch {
            print("Erro ao carregar imagem: \(error)")
        }
        return nil
    }
}


// MARK: - Células

private struct ExistingPhotoCell: View {
    let urlString: String
    let onRemove: () -> Void
    private let size = CGSize(width: 155, height: 155)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let url = URL(string: urlString) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .cornerRadius(CornerRadius.medium.rawValue)
            }
            RemoveButton(action: onRemove)
        }
    }
}

private struct NewPhotoCell: View {
    let fileURL: URL
    let isLoading: Bool
    let onRemove: () -> Void
    private let size = CGSize(width: 155, height: 155)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(contentsOfFile: fileURL.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .cornerRadius(CornerRadius.medium.rawValue)
                    .overlay {
                        if isLoading {
                            Rectangle()
                                .frame(width: size.width, height: size.height)
                                .cornerRadius(CornerRadius.medium.rawValue)
                                .modifier(ShimmerModifier())
                                .transition(.opacity)
                        }
                    }
            } else {
                Rectangle()
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(CornerRadius.medium.rawValue)
                    .modifier(ShimmerModifier())
                    .transition(.opacity)
            }
            

            RemoveButton(action: onRemove)
        }
    }
}

private struct AddPhotoSlot: View {
    let action: () -> Void
    private let size = CGSize(width: 155, height: 155)

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue)
                    .strokeBorder(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .background(Color.gray.opacity(0.1))

                SFIcon.image(.add, color: .gray)
            }
            .frame(width: size.width, height: size.height)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

private struct RemoveButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            SFIcon.image(.close, color: .red)
        }
        .buttonStyle(CircleTranslucentButtonStyle())
        .frame(width: 24, height: 24)
    }
}
