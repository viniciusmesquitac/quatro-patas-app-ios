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
                        CachedAsyncImage(
                            url: url
                        )
                        .tag(index)
                        .scaledToFill()
                        .clipped()
                        .frame(width: frame.width, height: frame.height)
                        .cornerRadius(8)
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
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(Color.primaryColor.opacity(0.5))
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
