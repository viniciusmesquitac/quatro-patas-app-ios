//
//  AnimalImagesGrid.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/09/25.
//
import SwiftUI
import PhotosUI

enum GridImage: Hashable, Transferable {
    case existing(String)
    case new(URL)
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .data) { image in
            // Exportação (drag)
            switch image {
            case .existing(let urlString):
                return Data(urlString.utf8) // Convertemos a string em Data
            case .new(let url):
                return try Data(contentsOf: url) // Lê o arquivo local
            }
        } importing: { data in
            // Importação (drop)
            // Aqui você decide como recriar o `GridImage`
            if let urlString = String(data: data, encoding: .utf8),
               urlString.starts(with: "http") {
                return .existing(urlString)
            } else {
                // Se for arquivo, precisamos salvar localmente
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
                try data.write(to: tempURL)
                return .new(tempURL)
            }
        }
    }
}

struct ImagesGrid: View {
    @Binding var existingPhotos: [String]
    @Binding var newImages: [URL]

    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var isLoading: [URL?: Bool] = [:]
    @State private var showPhotoPicker = false
    @State private var draggingItem: GridImage?
    @State private var allImages: [GridImage] = []

    let maxPhotos: Int

    private let columns = [
        GridItem(.adaptive(minimum: 155), spacing: Spacing.medium.rawValue)
    ]

    private var remainingSlots: Int {
        maxPhotos - allImages.count
    }

    @EnvironmentObject var navigator: Navigator

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.xxLarge.rawValue) {
            ForEach(allImages, id: \.self) { item in
                GeometryReader {
                    let size = $0.size

                    switch item {
                    case .existing(_):
                        cell(for: item)
                            .draggable(item) {
                                cell(for: item)
                                    .background(.ultraThinMaterial)
                                    .frame(width: 1, height: 1)
                                    .onAppear {
                                        draggingItem = item
                                    }
                            }
                            .dropDestination(for: GridImage.self) { items, location in
                                draggingItem = nil
                                return false
                            } isTargeted: { status in
                                if let draggingItem, status, draggingItem != item {
                                    handleDrag(draggingItem: draggingItem, item: item)
                                }
                            }
                    case .new(_):
                        cell(for: item)
                    }
                    
                }
                .frame(minHeight: 155)
            }

            if remainingSlots > 0 {
                ForEach(0..<remainingSlots, id: \.self) { _ in
                    AddPhotoSlot {
                        selectedPhotos.removeAll()
                        showPhotoPicker = true
                    }
                }
            }
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotos,
            maxSelectionCount: remainingSlots,
            matching: .images,
            photoLibrary: .shared()
        )
        .onAppear {
            allImages = existingPhotos.map { .existing($0) } + newImages.map { .new($0) }
        }
        .onChange(of: selectedPhotos) { _, newItems in
            handleSelectedPhotos(newItems)
        }
    }
    
    private func handleDrag(draggingItem: GridImage, item: GridImage) {
        if let sourceIndex = allImages.firstIndex(of: draggingItem),
           let destinationIndex = allImages.firstIndex(of: item) {
            withAnimation(.bouncy) {
                let sourceItem = allImages.remove(at: sourceIndex)
                allImages.insert(sourceItem, at: destinationIndex)

                existingPhotos = allImages.compactMap {
                    if case .existing(let value) = $0 { return value }
                    return nil
                }
                newImages = allImages.compactMap {
                    if case .new(let value) = $0 { return value }
                    return nil
                }
            }
        }
    }

    @ViewBuilder
    private func cell(for item: GridImage, preview: Binding<Bool> = .constant(false)) -> some View {
        switch item {
        case .existing(let urlString):
            ExistingPhotoCell(
                urlString: urlString,
                onRemove: {
                    navigator.present(sheet: .alert(
                        title: "Deseja realmente remover essa imagem?",
                        action: {
                            if let idx = existingPhotos.firstIndex(of: urlString) {
                                existingPhotos.remove(at: idx)
                            }
                            navigator.dismiss()
                        }
                    ))
                },
                preview: preview
            )

        case .new(let fileURL):
            NewPhotoCell(
                fileURL: fileURL,
                isLoading: isLoading[fileURL] ?? false,
                onRemove: {
                    Task { await onRemoveImage(at: fileURL) }
                }
            )
        }
    }

    private func handleSelectedPhotos(_ newItems: [PhotosPickerItem]) {
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

// MARK: - Identificador único para drag
private extension GridImage {
    var idString: String {
        switch self {
        case .existing(let str): return "existing-\(str)"
        case .new(let url): return "new-\(url.path)"
        }
    }
}

