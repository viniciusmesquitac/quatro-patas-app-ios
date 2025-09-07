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
    @State private var isFavorite = false

    let repository = FavoritesRepository()

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: Spacing.small.rawValue) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        ImageCarousel(
                            images: animal.photos.compactMap { URL(string: $0) },
                            selectedIndex: $selectedImageIndex
                        ).onTapGesture {
                            showFullScreen = true
                        }

                        Button(action: {
                            toggleFavorite()
                        }) {
                            SFIcon.image(isFavorite ? .heart_filled : .heart, scale: .medium, color: isFavorite ? .red : .black)
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
        .onAppear {
            isFavorite = repository.isFavorite(id: animal.id ?? String())
        }
    }
    
    func loadTags() -> [TagItem] {
        let tags = animal.tags.compactMap { AnimalTag(rawValue: $0) }
        return tags.map {
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
    
    func formatAge(_ timestampString: String) -> String {
        guard let timestamp = TimeInterval(timestampString) else { return "Idade desconhecida" }
        let birthDate = Date(timeIntervalSince1970: timestamp)
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: now)
        let years = components.year ?? 0
        let months = components.month ?? 0
        
        switch (years, months) {
        case (0, 0):
            return "Menos de 1 mês"
        case (0, 1):
            return "1 mês"
        case (0, let m):
            return "\(m) meses"
        case (1, 0):
            return "1 ano"
        case (let y, 0):
            return "\(y) anos"
        case (1, 1):
            return "1 ano e 1 mês"
        case (1, let m):
            return "1 ano e \(m) meses"
        case (let y, 1):
            return "\(y) anos e 1 mês"
        default:
            return "\(years) anos e \(months) meses"
        }
    }
    
    private func toggleFavorite() {
        guard let animalId = animal.id else { return }
        if isFavorite {
            repository.removeFavorite(id: animalId)
        } else {
            repository.addFavorite(id: animalId)
            toast("Adicionado aos favoritos!", .success)
        }
        isFavorite.toggle()
    }

}
