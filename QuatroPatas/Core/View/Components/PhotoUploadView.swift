//
//  PhotoUploadView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 26/09/25.
//

import SwiftUI
import PhotosUI

struct PhotoUploadView: View {
    let title: String
    @Binding var image: UIImage?

    @State private var showCamera = false
    @State private var showOptions = false

    @State private var showGallery = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack {
            Button {
                showOptions = true
            } label: {
                contentView
            }
        }
        .confirmationDialog(
            "Selecionar imagem",
            isPresented: $showOptions,
            titleVisibility: .visible
        ) {
            Button("Tirar foto") {
                showCamera = true
            }

            Button("Escolher da galeria") {
                showGallery = true
            }

            Button("Cancelar", role: .cancel) {}
        }
        .photosPicker(
            isPresented: $showGallery,
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedItem) { newItem in
            Task {
                guard let newItem else { return }
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.image = uiImage
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(image: $image)
                .ignoresSafeArea()
        }
    }

    private var contentView: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue))
            } else {
                RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .foregroundStyle(.gray)
                    .frame(width: 120, height: 120)
                    .overlay(
                        VStack(spacing: Spacing.medium.rawValue) {
                            SFIcon.image(.camera)
                            Text(title).font(.caption)
                        }
                        .foregroundStyle(.gray)
                    )
            }
        }
    }
}
