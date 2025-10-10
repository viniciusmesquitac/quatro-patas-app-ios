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
    var height: CGFloat = 400
    
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
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                    .overlay(
                        VStack(alignment: .center) {
                            SFIcon.image(.add, color: .gray)
                            Text("Adicionar fotos")
                                .font(.headline)
                                .padding(.top, Padding.small.rawValue)
                                .foregroundColor(.gray)
                        }
                    )
                    .onTapGesture { showPhotoPicker = true }
                
            } else {
                ImageCarousel(
                    images: images,
                    selectedIndex: $selectedIndex
                )
                .onTapGesture { showPhotoPicker = true }
            }
        }
    }
}
