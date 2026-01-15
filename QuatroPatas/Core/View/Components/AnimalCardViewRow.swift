//
//  AnimalCardViewRow.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/09/25.
//

import SwiftUI

struct AnimalCardViewRow: View {
    let animal: Animal
    var action: (() -> Void)? = nil

    @CacheProvider(type: .fileManager)
    var cacheProvider
    
    private enum Constants {
        static let imageSize: CGFloat = 70
        static let cornerRadius: CGFloat = 8
        static let nameFontSize: CGFloat = 18
        static let ageFontSize: CGFloat = 14
    }
    
    var body: some View {
        Button(action: action ?? { }) {
            HStack(spacing: Spacing.large.rawValue) {
                if let firstURL = animal.photos.first, let url = URL(string: firstURL) {
                    CachedAsyncImage(url: url)
                        .scaledToFill()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
                
                VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                    HStack {
                        Text(animal.name)
                            .font(.system(size: Constants.nameFontSize, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        if animal.isAdopted {
                            Spacer()
                            Text("Adotado")
                                .font(.system(size: 12, weight: .bold))
                                .padding(.horizontal, Padding.medium.rawValue)
                                .padding(.vertical, Padding.small.rawValue)
                                .background(Color.primaryColor)
                                .foregroundColor(.customBackground)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text(DateHelper.formatCreatedAt(animal.createdAt))
                        .font(.system(size: Constants.ageFontSize))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(NoneButtonStyle())
    }
}
