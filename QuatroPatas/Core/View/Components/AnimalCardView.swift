//
//  AnimalCardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/07/25.
//

import SwiftUI

struct AnimalCardView: View {
    let animal: Animal
    let action: () -> Void
    
    private enum Constants {
        // Font
        static let gradientOpacity: CGFloat = 0.6
        static let animalNameFontSize: CGFloat = 24
        // Size
        static let width: CGFloat = 155
        static let height: CGFloat = 180
    }

    private var gradient: Gradient {
        Gradient(colors: [
            Color.black.opacity(Constants.gradientOpacity),
            Color.clear
        ])
    }

    private var LinearGradientEffect: some View {
        LinearGradient(gradient: gradient,
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var AnimalNameView: some View {
        VStack {
            Spacer()
            Text(animal.name)
                .padding(.leading, Padding.medium.rawValue)
                .font(.system(size: Constants.animalNameFontSize, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradientEffect)
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                GeometryReader { geometry in
                    if let firstURL = animal.photos.first,
                       let url = URL(string: firstURL) {
                        CachedAsyncImage(
                            url: url
                        )
                        .scaledToFill()
                        .clipped()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay {
                            AnimalNameView
                        }
                        .cornerRadius(CornerRadius.small.rawValue)

                    }
                }
            }.frame(width: Constants.width, height: Constants.height)
        }.buttonStyle(CardButtonStyle())
    }
}
