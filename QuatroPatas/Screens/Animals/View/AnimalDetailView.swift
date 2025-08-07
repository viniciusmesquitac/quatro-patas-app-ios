//
//  AnimalDetailView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct AnimalDetailView: View {
    let animal: Animal
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        ScrollView {
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
                
                Button(action: {
                    print("adotar")
                }) {
                    Text("Adotar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .backButton()
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("share")
                    }) {
                        SFIcons.image(.share)
                    }
                }
            }
            
        }
    }
}

