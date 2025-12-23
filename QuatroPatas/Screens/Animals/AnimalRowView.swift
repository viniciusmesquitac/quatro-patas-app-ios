//
//  AnimalRowView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 29/09/25.
//

import SwiftUI

struct AnimalRowView: View {
    let animal: Animal
    let action: () -> Void
    
    var body: some View {
        HStack {
            if let firstURL = animal.photos.first,
               let url = URL(string: firstURL) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .clipped()
                    .frame(width: 180, height: 180)
                    .cornerRadius(CornerRadius.medium.rawValue, corners: [.topLeft, .bottomLeft])
            }
            
            VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                Text(animal.name)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .shimmer(if: animal == .empty)

                Text("\(animal.ageFormatted)")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .shimmer(if: animal == .empty)
        
                Text(animal.localized.gender)
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .shimmer(if: animal == .empty)
                
                TagsView(tags: loadTags())
            }
            .padding(.horizontal, Padding.medium.rawValue)
        }
        .background(Color.customBackground)
        .cornerRadius(CornerRadius.medium.rawValue)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
    
    func loadTags() -> [TagItem] {
        let tags = animal.tags.compactMap { AnimalTag(rawValue: $0) }
        return tags.reduce(into: [TagItem]()) { result, tag in
            if tag == .vaccinated || tag == .neutered {
                result.append(TagItem(tag: tag))
            }
        }
    }
}
