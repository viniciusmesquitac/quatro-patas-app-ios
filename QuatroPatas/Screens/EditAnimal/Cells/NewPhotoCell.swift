//
//  NewPhotoCell.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/10/25.
//

import SwiftUI

struct NewPhotoCell: View {
    let fileURL: URL
    let isLoading: Bool
    let onRemove: () -> Void
    private let size = CGSize(width: 155, height: 155)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(contentsOfFile: fileURL.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .cornerRadius(CornerRadius.medium.rawValue)
                    .overlay {
                        if isLoading {
                            Rectangle()
                                .frame(width: size.width, height: size.height)
                                .cornerRadius(CornerRadius.medium.rawValue)
                                .modifier(ShimmerModifier())
                                .transition(.opacity)
                        }
                    }
            } else {
                Rectangle()
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(CornerRadius.medium.rawValue)
                    .modifier(ShimmerModifier())
                    .transition(.opacity)
            }
            

            RemoveButton(action: onRemove)
        }
    }
}

struct RemoveButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            SFIcon.image(.close, color: .red)
        }
        .buttonStyle(CircleTranslucentButtonStyle())
        .frame(width: 24, height: 24)
    }
}

