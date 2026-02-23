//
//  CachedAsyncImage.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/09/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?

    @CacheProvider(type: .fileManager)
    private var cacheProvider
    
    @State private var attempt = 0

    @Binding var isLoading: Bool?
    
    init(url: URL?, isLoading: Binding<Bool?> = .constant(nil)) {
        self.url = url
        self._isLoading = isLoading
    }

    var body: some View {
        if let url, url.isFileURL, let uiImage = UIImage(contentsOfFile: url.path) {
            Image(uiImage: uiImage)
                .resizable()
                .onAppear { isLoading = false }
        }
        else if let url,
                let imageData = cacheProvider.get(key: url.getImageToken()) as? Data,
                let cachedImage = UIImage(data: imageData) {
            Image(uiImage: cachedImage)
                .resizable()
                .onAppear { isLoading = false }
        }
        else {
            AsyncImage(url: url, transaction: .init(animation: .spring(duration: 1))) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .onAppear {
                            isLoading = false
                            if let url = url {
                                SaveImageProvider(provider: cacheProvider).saveImageData(url: url)
                            }
                        }
                case .failure(_):
                    Rectangle()
                        .background(Color.gray)
                        .onAppear {
                            isLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                attempt += 1
                            }
                        }
                case .empty:
                    Rectangle()
                        .background(Color.gray)
                        .modifier(ShimmerModifier())
                @unknown default:
                    EmptyView()
                }
            }
            .id(attempt)
        }
    }
}
