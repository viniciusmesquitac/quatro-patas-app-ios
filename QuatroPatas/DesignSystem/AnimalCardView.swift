//
//  AnimalCardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/07/25.
//


import SwiftUI

struct AnimalCardView: View {
    let animal: Animal
    
    private enum Constants {
        // Animal Name
        static let gradientOpacity: CGFloat = 0.6
        static let animalNameLeading: CGFloat = 8
        static let animalNameFontSize: CGFloat = 24

        // Animal Image
        static let imageCornerRadius: CGFloat = 8
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
                .padding(EdgeInsets(
                    top: .zero,
                    leading: Constants.animalNameLeading,
                    bottom: .zero,
                    trailing: .zero
                ))
                .font(.system(size: Constants.animalNameFontSize, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradientEffect)
        }
    }
    
    
    private var AdoptTagView: some View {
        GeometryReader { geometry in
            Circle()
                .fill(Color.pink)
                .frame(width: geometry.size.height / 4, height: geometry.size.height / 4)
                .overlay(
                    Text("Me\nadota")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                )
                .offset(x: geometry.size.width / 1.4, y: geometry.size.height / 1.2)
        }
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image(animal.photo ?? "default-animal-card.png")
                    .resizable()
                    .cornerRadius(Constants.imageCornerRadius)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        AnimalNameView
                        AdoptTagView
                    })
            }
        }
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
            description: "Castrada, vermifugada, Vacinada"
        ))
        .previewLayout(PreviewLayout.fixed(width: 150, height: 320))
    }
}
