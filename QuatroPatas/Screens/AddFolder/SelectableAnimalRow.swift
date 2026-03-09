//
//  SelectableAnimalRow.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/01/26.
//

import SwiftUI

struct SelectableAnimalRow: View {

    let animal: Animal
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: Spacing.large.rawValue) {
            if let firstURL = animal.photos.first, let url = URL(string: firstURL) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .frame(width: 70, height: 50)
                    .clipShape(Circle())
            }
            
            Text(animal.name)

            Spacer()

            if isSelected {
                SFIcon.image(.success)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.15) : Color.clear)
        )
        .contentShape(Rectangle()) // permite tocar na row inteira
        .onTapGesture {
            action()
        }
    }
}
