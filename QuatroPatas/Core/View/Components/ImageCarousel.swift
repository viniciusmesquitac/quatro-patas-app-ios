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
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .clipped()
                    .frame(width: frame.width, height: frame.height)
                    .transition(.scale)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: frame.height)
        .ignoresSafeArea(edges: .top)
    }
}

