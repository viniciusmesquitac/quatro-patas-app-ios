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
    
    @State private var selectedImageIndex = 0
    @State private var showFullScreen = false

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: Spacing.small.rawValue) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        ImageCarousel(
                            images: animal.photos,
                            selectedIndex: $selectedImageIndex
                        ).onTapGesture {
                            showFullScreen = true
                        }

                        Button(action: {
                            toast("Adicionado aos favoritos!", .success)
                        }) {
                            SFIcon.image(.heart)
                        }
                        .buttonStyle(CircleButtonStyle())
                        .offset(x: -25, y: 25)
                    }

                    // conteúdo abaixo da imagem
                    VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {

                        Text(animal.name + ", " + formatAge(animal.age))
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        TagsView(tags: loadTags())

                        Text(animal.description)
                            .padding(.top)

                        Spacer()

                        Button(action: {
                            navigator.present(sheet: .tip(
                                Tip(title: Tip.adoption.title,
                                    description: Tip.adoption.description,
                                    buttonText: "Entendi!",
                                    buttonAction: {
                                        navigator.dismiss()
                                        navigator.navigate(to: .adoptionForm)
                                    })
                            ))
                        }) {
                            Text("Adotar")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    .fullScreenCover(isPresented: $showFullScreen) {
                        ZoomableCarouselView(images: animal.photos,
                                             selectedIndex: $selectedImageIndex)
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
    
    func loadTags() -> [TagItem] {
        animal.tags.map {
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
        }
    }
    
    func formatAge(_ age: String) -> String {
        if age.hasSuffix("y") {
            if let years = Int(age.dropLast()) {
                let suffixYear =  years > 1 ? "s" : ""
                return "\(years) ano\(suffixYear)"
            }
        } else if age.hasSuffix("m") {
            if let count = Int(age.dropLast()) {
                let suffixMonth =  count > 1 ? "s" : ""
                return "\(count) mese\(suffixMonth)"
            }
        }
        return age
    }

}
