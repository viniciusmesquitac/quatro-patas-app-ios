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
    
    private let imagePlaceholder = "default-animal-card.png"

    var body: some View {
        if let url, url.isFileURL, let uiImage = UIImage(contentsOfFile: url.path) {
            Image(uiImage: uiImage)
                .resizable()
        }
        else if let url,
                let imageData = cacheProvider.get(key: getToken(url: url)) as? Data,
                let cachedImage = UIImage(data: imageData) {
            Image(uiImage: cachedImage)
                .resizable()
        }
        else {
            AsyncImage(url: url, transaction: .init(animation: .spring(duration: 1))) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .modifier(ShimmerModifier())
                case .success(let image):
                    image
                        .resizable()
                        .onAppear {
                            if let url = url {
                                saveImageData(url: url)
                            }
                        }
                case .failure(_):
                    Image(imagePlaceholder)
                        .resizable()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                attempt += 1
                            }
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .id(attempt)
        }
    }

    private func getToken(url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
            return url.absoluteString
        }
        return token
    }

    private func saveImageData(url: URL) {
        let token = getToken(url: url)
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                try? cacheProvider.save(data, for: token)
            }
        }.resume()
    }
}
