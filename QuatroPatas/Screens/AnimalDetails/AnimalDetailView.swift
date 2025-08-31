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
    
    @Environment(\.toast) private var toast

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: Spacing.small.rawValue) {
                    
                    // Imagem ocupando toda largura da tela
                    Image(animal.photo ?? "default-animal-card.png")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 500)
                        .clipped()
                        .ignoresSafeArea(edges: .top)

                    // Conteúdo abaixo da imagem
                    VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
                        Text(animal.name + ", " + animal.age)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        TagsView(tags: animal.tags.map {
                            if $0 == .vaccinated {
                                return TagItem(tag: $0, action: {
                                    navigator.present(sheet: .tip(Tip.vaccinated))
                                })
                            }
                            if $0 == .neutered {
                                return TagItem(tag: $0, action: {
                                    navigator.present(sheet: .tip(Tip.neutered))
                                })
                            }
                            if $0 == .felv {
                                return TagItem(tag: $0, action: {
                                    navigator.present(sheet: .tip(Tip.felv))
                                })
                            }
                            return TagItem(tag: $0, action: {})
                        })

                        Text(animal.description)
                            .padding(.top)
                        
                        Spacer()
                        
                        Button(action: {
                            navigator.present(sheet: .tip(
                                Tip(title: Tip.adoption.title, description: Tip.adoption.description, buttonText: "Entendi!", buttonAction: {
                                    navigator.dismiss()
                                    navigator.navigate(to: .adoptionForm)
                                })
                            ))
                        }) {
                            Text("Adotar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primaryColor)
                                .foregroundColor(.white)
                                .cornerRadius(CornerRadius.medium.rawValue)
                        }
                    }
                    .padding()
                }
            }.ignoresSafeArea(edges: .top)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbarMenu(icon: .more, placement: .topBarTrailing, actions: [
            ToolbarMenuAction(label: "Compartilhar", icon: .share) {
                navigator.present(sheet: .share(items: []))
            },
        ])
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
    }
}
