//
//  AnimalImagesCarousel.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 08/09/25.
//

import SwiftUI
import PhotosUI

struct AnimalImagesCarousel: View {
    @Binding var existingPhotos: [String]
    @Binding var newImages: [URL]
    @Binding var selectedPhotos: [PhotosPickerItem]
    @Binding var showPhotoPicker: Bool
    @Binding var selectedIndex: Int

    var onRemoveExisting: ((Int) -> Void)?
    var onRemoveNew: ((Int) -> Void)?
    
    var frame = CGSize(width: UIScreen.main.bounds.width, height: 400)
    
    @CacheProvider(type: .fileManager)
    var cacheProvider
    
    var allImages: [URL] {
        let firebase = existingPhotos.compactMap { URL(string: $0) }
        return firebase + newImages
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
            TabView(selection: $selectedIndex) {
                ForEach(allImages.indices, id: \.self) { index in
                    let url = allImages[index]
                    
                    ZStack(alignment: .topTrailing) {
                        
                        // 🚀 caso local (file://) → sem cache
                        if url.isFileURL {
                            if let uiImage = UIImage(contentsOfFile: url.path) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: frame.width, height: frame.height)
                                    .clipped()
                                    .tag(index)
                            }
                        }
                        
                        // 🌐 caso remoto (com cache)
                        else {
                            if let imageData = cacheProvider.get(key: getToken(url: url)) as? Data,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: frame.width, height: frame.height)
                                    .clipped()
                                    .tag(index)
                            } else {
                                AsyncImage(url: url, transaction: .init(animation: .spring(duration: 2))) { phase in
                                    switch phase {
                                    case .empty:
                                        Rectangle()
                                            .frame(width: frame.width, height: frame.height)
                                            .modifier(ShimmerModifier())
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: frame.width, height: frame.height)
                                            .clipped()
                                            .transition(.opacity)
                                            .onAppear {
                                                saveImageData(url: url)
                                            }
                                    default:
                                        Image("default-animal-card.png")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: frame.width, height: frame.height)
                                            .clipped()
                                    }
                                }
                                .tag(index)
                            }
                        }
                        
                        // ❌ Botão de remover
                        Button {
                            if index < existingPhotos.count {
                                onRemoveExisting?(index)
                            } else {
                                onRemoveNew?(index - existingPhotos.count)
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .foregroundStyle(Color.primaryColor)
                        }
                        .padding(8)
                    }
                }
                
                // ➕ Botão para adicionar
                VStack {
                    Button {
                        showPhotoPicker = true
                    } label: {
                        VStack {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                            Text("Adicionar")
                                .font(.caption)
                        }
                        .frame(width: frame.width, height: frame.height)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                .tag(allImages.count)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: frame.height)
        }
    }
    
    // MARK: - Helpers
    func getToken(url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
            return url.absoluteString
        }
        return token
    }
    
    func saveImageData(url: URL) {
        let token = getToken(url: url)
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                try? cacheProvider.save(data, for: token)
            }
        }.resume()
    }
}
