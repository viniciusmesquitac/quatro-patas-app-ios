//
//  AnimalImagesGrid.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/09/25.
//
import SwiftUI
import PhotosUI

enum GridImage: Hashable {
    case existing(String) // foto salva no servidor
    case new(URL)         // foto adicionada localmente
}

struct ImagesGrid: View {
    @Binding var existingPhotos: [String]
    @Binding var newImages: [URL]

    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var isLoading: [URL?: Bool] = [:]
    @State private var showPhotoPicker = false
    @State private var draggingItem: GridImage?

    let maxPhotos: Int
    private let columns = [
        GridItem(.adaptive(minimum: 155), spacing: Spacing.medium.rawValue)
    ]

    private var allImages: [GridImage] {
        existingPhotos.map { .existing($0) } + newImages.map { .new($0) }
    }

    private var remainingSlots: Int {
        maxPhotos - allImages.count
    }

    @EnvironmentObject var navigator: Navigator

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.xxLarge.rawValue) {
            ForEach(allImages, id: \.self) { item in
                cell(for: item)
                    .opacity(draggingItem == item ? 0.3 : 1.0)
                    .onDrag {
                        self.draggingItem = item
                        return NSItemProvider(object: item.idString as NSString)
                    }
                    .onDrop(of: [.text],
                            delegate: DropViewDelegate(
                                current: item,
                                items: allImages,
                                draggingItem: $draggingItem,
                                onMove: reorder
                            ))
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
        .animation(.easeInOut(duration: 0.25), value: allImages)
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

    @ViewBuilder
    private func cell(for item: GridImage) -> some View {
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
                }
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

    private func reorder(from: GridImage, to: GridImage) {
        var current = allImages
        guard let fromIndex = current.firstIndex(of: from),
              let toIndex = current.firstIndex(of: to),
              fromIndex != toIndex else { return }

        current.move(fromOffsets: IndexSet(integer: fromIndex),
                     toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)

        // separar de volta para existingPhotos e newImages
        existingPhotos = current.compactMap {
            if case let .existing(url) = $0 { return url }
            return nil
        }
        newImages = current.compactMap {
            if case let .new(url) = $0 { return url }
            return nil
        }
    }

    func onRemoveImage(at fileURL: URL) async {
        if let index = newImages.firstIndex(of: fileURL) {
            newImages.remove(at: index)
        }
    }
}

// MARK: - Drop Delegate
struct DropViewDelegate: DropDelegate {
    let current: GridImage
    let items: [GridImage]
    @Binding var draggingItem: GridImage?
    let onMove: (GridImage, GridImage) -> Void

    func performDrop(info: DropInfo) -> Bool {
        draggingItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggingItem = draggingItem,
              draggingItem != current else { return }
        onMove(draggingItem, current)
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

