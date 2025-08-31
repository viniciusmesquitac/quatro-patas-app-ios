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

        // Image
        static let cornerRadius: CGFloat = 8

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
                .padding(.leading, 8)
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
                    Image(animal.photos.first ?? "default-animal-card.png")
                        .resizable()
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        .aspectRatio(contentMode: .fill)
                        .overlay(content: {
                            AnimalNameView
                        })
                        .cornerRadius(CornerRadius.small.rawValue)
                }
            }
            .frame(width: Constants.width, height: Constants.height)
        }
        .buttonStyle(CardButtonStyle())
    }
}


struct AnimalCardView_Preview: PreviewProvider {

    static var previews: some View {
        AnimalCardView(animal: Animal(
            id: "0",
            name: "Priscila",
            age: "2 anos",
            gender: .female,
            type: .cat,
            breed: .mixed, color: .blackAndWhite,
            description: "Castrada, vermifugada, Vacinada"
        ), action: {})
        .previewLayout(PreviewLayout.fixed(width: 150, height: 180))
    }
}
