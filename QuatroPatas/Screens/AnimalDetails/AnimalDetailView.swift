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
                            navigator.present(sheet: .tip("Vacinação", ""))
                        })
                    }
                    if $0 == .neuthered {
                        return TagItem(tag: $0, action: {
                            navigator.present(sheet: .tip("Castração", ""))
                        })
                    }
                    if $0 == .felv {
                        return TagItem(tag: $0, action: {
                            navigator.present(sheet: .tip("O que é FeLV?", """
                                                          O vírus da leucemia felina (FeLV) é uma doença viral grave que afeta gatos.
                                                          Ele compromete o sistema imunológico, tornando o animal mais suscetível a outras doenças e podendo levar ao desenvolvimento de câncer.
                                                          
                                                          A transmissão ocorre principalmente pelo contato direto com saliva, secreções nasais, ou por arranhões e mordidas de gatos infectados.
                                                          Gatos que vivem em ambientes com múltiplos felinos têm maior risco de infecção.
                                                          
                                                          Não há cura definitiva, mas a prevenção é possível através da vacinação, testes regulares e evitando contato com gatos infectados.
                                                        """
                                                         ))
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
                ToolbarMenuAction(label: "Editar", icon:.share) {
                    navigator.dismiss()
                    toast("Editado com sucesso!", .success)
                },
                ToolbarMenuAction(label: "Deletar", icon: .share) {
                    navigator.dismiss()
                    toast("Deletado com sucesso!", .success)
                },
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

