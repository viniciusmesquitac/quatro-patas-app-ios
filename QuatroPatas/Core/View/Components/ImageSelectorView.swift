//
//  ImageSelectorView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/09/25.
//


import SwiftUI

struct ImageSelectorView: View {
    var images: [URL]
    @Binding var selectedIndex: Int
    @Binding var showPhotoPicker: Bool
    var isLoading: Bool = false
    var height: CGFloat = 250
    
    var body: some View {
        ZStack {
            if isLoading {
                RoundedRectangle(cornerRadius: .zero)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                    .overlay(
                        ProgressView("Carregando fotos...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    )
            } else if images.isEmpty {
                RoundedRectangle(cornerRadius: .zero)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                    .onTapGesture { showPhotoPicker = true }
            } else {
                ImageCarousel(
                    images: images,
                    selectedIndex: $selectedIndex,
                    frame: CGSize(width: UIScreen.main.bounds.width, height: height)
                )
                .onTapGesture { showPhotoPicker = true }
            }
        }
    }
}
