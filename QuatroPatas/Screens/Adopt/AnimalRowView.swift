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
                    .frame(width: 130, height: 180)
                    .cornerRadius(CornerRadius.medium.rawValue, corners: [.topLeft, .bottomLeft])
            }
            
            VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                Text(animal.name)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("\(animal.ageFormatted)")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
        
                Text(animal.localized.gender)
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                
                Spacer(minLength: 0)
            }
            .padding(.top, Padding.medium.rawValue)
            .padding(.horizontal, Padding.medium.rawValue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.customBackground)
        .cornerRadius(CornerRadius.medium.rawValue)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}
