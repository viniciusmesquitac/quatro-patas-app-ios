//
//  ExistingPhotoCell.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/10/25.
//

import SwiftUI

struct ExistingPhotoCell: View {
    let urlString: String
    let onRemove: () -> Void
    private let size = CGSize(width: 155, height: 155)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let url = URL(string: urlString) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .cornerRadius(CornerRadius.medium.rawValue)
            }
            RemoveButton(action: onRemove)
        }
    }
}
