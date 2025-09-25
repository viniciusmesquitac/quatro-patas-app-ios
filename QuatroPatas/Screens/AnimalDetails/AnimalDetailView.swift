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
    @EnvironmentObject var userSession: UserSession
    @CacheProvider(type: .fileManager) var cacheProvider
    
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
                            SFIcon.image(isFavorite ? .heart_filled : .heart, scale: .large, color: isFavorite ? .red : .customBackground)
                        }
                        .buttonStyle(CircleButtonStyle())
                        .offset(x: -25, y: 25)
                    }

                    // conteúdo abaixo da imagem
                    VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {

                        Text(animal.name + ", " + AgeHelper.formatAge(from: animal.age))
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        TagsView(tags: loadTags())

                        Text(animal.description)
                            .padding(.top)

                        Spacer()

                        Button(action: {
                            if userSession.user?.type == .volunteer {
                                registerAdoption()
                            } else {
                                adopt()
                            }
                        }) {
                            Text(userSession.user?.type == .volunteer ? "Cadastrar adoção" : "Adotar")
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
        .navigationBarHidden(true)

        .onAppear {
            isFavorite = repository.isFavorite(id: animal.id ?? String())
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    navigator.dismiss()
                } label: {
                    SFIcon.image(.back, color: .customLabel)
                }
                .buttonStyle(FloatingButtonStyle())
                
                Spacer()
                
                Button {
                    shareAnimal()
                } label: {
                    SFIcon.image(.share, color: .customLabel)
                }
                .buttonStyle(FloatingButtonStyle())
            }.padding(.horizontal)
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
            
            if $0 == .dewormed {
                return TagItem(tag: $0, action: {
                    navigator.present(sheet: .tip(Tip.dewormed))
                })
            }
            
            if $0 == .fiv {
                return TagItem(tag: $0, action: {
                    navigator.present(sheet: .tip(Tip.fiv))
                })
            }
            return TagItem(tag: $0, action: {})
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
    
    func getToken(url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
            return url.absoluteString
        }
        return token
    }
    
    func shareAnimal() {
        Task {
            var items: [Any] = []
            let message = "🐾 Conheça \(animal.name)! Ele(a) está disponível para adoção pelo @4patasfortaleza. ❤️\n\nAdotar é salvar uma vida!"
            items.append(message)
            
            if let url = URL(string: animal.photos.first ?? String()),
               let imageData = cacheProvider.get(key: getToken(url: url)) as? Data,
               let uiImage = UIImage(data: imageData) {
                items.append(uiImage)
            }
            navigator.present(sheet: .share(items: items))
            
        }
    }
    
    func adopt() {
        navigator.present(sheet: .tip(
            Tip(title: Tip.adoption.title,
                description: Tip.adoption.description,
                buttonText: "Entendi!",
                buttonAction: {
                    navigator.dismiss()
                    navigator.navigate(to: .adoptionForm)
                })
        ))
    }
    
    func registerAdoption() {
        navigator.present(sheet: .tip(
            Tip(title: Tip.registerAdoption.title,
                description: Tip.registerAdoption.description,
                buttonText: "Tudo certo!",
                buttonAction: {
                    navigator.dismiss()
                    navigator.navigate(to: .adoptionForm)
                })
        ))
    }
}
