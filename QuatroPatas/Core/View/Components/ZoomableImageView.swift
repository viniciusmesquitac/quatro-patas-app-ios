//
//  ZoomableImageView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/09/25.
//

import SwiftUI

struct ZoomableImage: View {
    let imageName: String
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geo in
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: geo.size.width, height: geo.size.height)
                .scaleEffect(scale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = lastScale * value
                        }
                        .onEnded { _ in
                            lastScale = scale
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation {
                        scale = 1.0
                        lastScale = 1.0
                    }
                }
        }
    }
}

struct ZoomableCarouselView: View {
    let images: [String]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(images.indices, id: \.self) { index in
                ZoomableImage(imageName: images[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black.ignoresSafeArea())
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
