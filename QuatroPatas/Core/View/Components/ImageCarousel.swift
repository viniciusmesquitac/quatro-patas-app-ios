//
//  ImageCarousel.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/08/25.
//

import SwiftUI
struct ImageCarousel: View {
    let images: [URL]
    @Binding var selectedIndex: Int
    var frame = CGSize(width: UIScreen.main.bounds.width, height: 500)
    
    @CacheProvider(type: .fileManager)
    var cacheProvider
    
    @State private var attempt = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(images.indices, id: \.self) { index in
                let url = images[index]
                
                // 🚀 caso local (file://)
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
                
                // 🌐 caso remoto
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
                                RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue)
                                    .frame(width: frame.width, height: frame.height)
                                    .modifier(ShimmerModifier())
                            case .success(let image):
                                withAnimation {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: frame.width, height: frame.height)
                                        .clipped()
                                        .transition(.scale)
                                        .onAppear {
                                            saveImageData(url: url)
                                        }
                                }
                            case .failure(_):
                                Image("default-animal-card.png")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: frame.width, height: frame.height)
                                    .clipped()
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            attempt += 1
                                        }
                                    }
                            }
                        }
                        .id(attempt) // recria AsyncImage → força retry
                        .tag(index)
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: frame.height)
        .ignoresSafeArea(edges: .top)
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
                do {
                    try cacheProvider.save(data, for: token)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
