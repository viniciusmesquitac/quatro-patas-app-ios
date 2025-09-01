//
//  ImageCarousel.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/08/25.
//

import SwiftUI

struct ImageCarousel: View {
    let images: [String]
    @Binding var selectedIndex: Int
    var frame = CGSize(width: UIScreen.main.bounds.width, height: 500)

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .frame(width: frame.width, height: frame.height)
                    .clipped()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: frame.height)
        .ignoresSafeArea(edges: .top)
    }
}
