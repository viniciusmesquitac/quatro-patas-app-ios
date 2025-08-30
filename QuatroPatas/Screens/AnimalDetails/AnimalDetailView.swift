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
        ScrollView {
            VStack(spacing: Spacing.xLarge.rawValue) {
                Image(animal.photo ?? "default-animal-card.png")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                
                Text(animal.name + ", " + animal.age)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TagsView(tags: animal.tags.map {
                    if $0 == .vaccinated {
                        return TagItem(tag: $0, action: {
                            navigator.present(sheet: .tip(Tip(title:"Vacinação", descripition: "")))
                        })
                    }
                    if $0 == .neutered {
                        return TagItem(tag: $0, action: {
                            navigator.present(sheet: .tip(Tip(title: "Castração", descripition: "")))
                        })
                    }
                    if $0 == .felv {
                        return TagItem(tag: $0, action: {
                            navigator.present(sheet: .tip(Tip.felv))
                        })
                    }
                    return TagItem(tag: $0, action: {
                        
                    })
                })
                Text(animal.description)
                    .padding()

                Spacer()
                
                Button(action: {
                    navigator.popToRoot()
                    toast("Salvo com sucesso!", .success)
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
}

