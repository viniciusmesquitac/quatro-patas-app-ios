//
//  AnimalDetailView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct AnimalDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let animal: Animal

    var body: some View {
        VStack(spacing: 20) {
            Image(animal.photo ?? "default-animal-card.png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)

            Text(animal.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Idade: \(animal.age)")
            Text(animal.description)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Detalhes do Animal")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
    }
}

