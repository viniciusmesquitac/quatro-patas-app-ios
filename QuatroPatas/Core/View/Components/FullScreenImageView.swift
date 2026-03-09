//
//  FullScreenImageView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 26/09/25.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageURL: URL
    var onDismiss: () -> Void
    
    @Environment(\.toast) var toast
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            
            CachedAsyncImage(url: imageURL)
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: onDismiss) {
                        SFIcon.image(.close)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()

                    Button(action: saveImage) {
                        SFIcon.image(.download)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
    
    private func saveImage() {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                if let uiImage = UIImage(data: data) {
                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                }
                toast("Iamgem salva com sucesso!", .success)
            } catch {
                toast("Error ao salvar com sucesso!", .error)
            }
        }
    }
}
