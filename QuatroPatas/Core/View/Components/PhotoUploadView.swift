//
//  PhotoUploadView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 26/09/25.
//

import SwiftUI

struct PhotoUploadView: View {
    let title: String
    @Binding var image: UIImage?

    @State private var showCamera = false

    var body: some View {
        VStack {
            Button {
                showCamera = true
            } label: {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                        .foregroundStyle(.gray)
                        .frame(width: 120, height: 120)
                        .overlay(
                            VStack {
                                Image(systemName: "camera")
                                Text(title)
                                    .font(.caption)
                            }
                            .foregroundStyle(.gray)
                        )
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $image)
        }
    }
}
