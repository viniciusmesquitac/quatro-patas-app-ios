//
//  ZoomableImageView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/09/25.
//

import SwiftUI

struct ZoomableImage: View {
    var imageURL: URL
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            CachedAsyncImage(url: imageURL)
                .scaledToFit()
                .frame(width: geo.size.width, height: geo.size.height)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            .onEnded { _ in
                                lastScale = scale
                            },
                        
                        DragGesture()
                            .onChanged { value in
                                if scale > 1 {
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                            }
                            .onEnded { _ in
                                if scale > 1 {
                                    lastOffset = offset
                                } else {
                                    // reset offset se não estiver em zoom
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                    )
                )
                .onTapGesture(count: 2) {
                    withAnimation {
                        scale = 1.0
                        lastScale = 1.0
                        offset = .zero
                        lastOffset = .zero
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
                if let url = URL(string: images[index]) {
                    ZoomableImage(imageURL: url)
                        .tag(index)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .background(Color.black.ignoresSafeArea())
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
