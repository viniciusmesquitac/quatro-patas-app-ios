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
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @CacheProvider(type: .fileManager) var cacheProvider
    
    @Environment(\.toast) private var toast
    
    @Environment(\.colorScheme) private var systemScheme

    @State private var selectedImageIndex = 0
    @State private var showFullScreen = false
    @State private var isFavorite = false
    @State private var isLoading = false

    let repository = FavoritesRepository()
    
    @Environment(\.colorScheme) var colorScheme
    
    var image: some View {
        ImageCarousel(
            images: animal.photos.compactMap { URL(string: $0) },
            selectedIndex: $selectedImageIndex
        )
        .stretchy()
        .onTapGesture {
            showFullScreen = true
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: Spacing.small.rawValue) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        image

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

                        Text(animal.name + ", " + animal.ageFormatted)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        TagsView(tags: loadTags())

                        Text(animal.description)
                            .padding(.top)

                        Spacer()

                        Button(action: {
                            if userSession.user?.type == .ngo {
                                registerAdoption()
                            } else {
                                adopt()
                            }
                        }) {
                            Text(userSession.user?.type == .ngo ? "Cadastrar adoção" : "Quero Adotar")
                        }
                        .buttonStyle(PrimaryButtonStyle(isLoading: isLoading))
                    }
                    .fullScreenCover(isPresented: $showFullScreen) {
                        ZoomableCarouselView(images: animal.photos,
                                             selectedIndex: $selectedImageIndex)
                    }
                    .padding()
                }
            }.ignoresSafeArea(edges: .top)
        }
        .toolbarColorScheme(colorScheme, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .toolbarItem(icon: .share, placement: .topBarTrailing, action: {
            shareAnimal()
        })
        .onAppear {
            isFavorite = repository.isFavorite(id: animal.id ?? String())
        }
    }
    
    func loadTags() -> [TagItem] {
        animal.tags
            .compactMap { AnimalTag(rawValue: $0) }
            .map { $0.makeTagItem(using: navigator) }
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
    
    func shareAnimal() {
        Task {
            var items: [Any] = []
            let message = "🐾 Conheça \(animal.name)! Ele(a) está disponível para adoção pelo @4patasfortaleza. ❤️\n\nAdotar é salvar uma vida!"
            items.append(message)
            
            if let url = URL(string: animal.photos.first ?? String()),
               let imageData = cacheProvider.get(key: url.getImageToken()) as? Data,
               let uiImage = UIImage(data: imageData) {
                items.append(uiImage)
            }
            navigator.present(sheet: .share(items: items))
            
        }
    }
    
    func adopt() {
        openForms()
    }
    
    func openForms() {
        guard let ownerId = animal.ownerId else {
            navigator.dismiss()
            toast("formulário ainda não está dispónivel", .warning)
            return
        }
        Task {
            do {
                isLoading = true
                let user: User? = try await databaseProvider.fetchDocument(from: "users", id: ownerId)
                let validGoogleFormsHosts = ["forms.gle", "docs.google.com"]
                let form = animal.type == AnimalType.cat.caseName ? user?.formCat : user?.formDog

                if
                    let form = form,
                    let url = URL(string: form),
                    let host = url.host,
                    validGoogleFormsHosts.contains(host)
                {
                    let isValid = await validateGoogleForm(url: url)

                    if isValid {
                        isLoading = false
                        navigator.present(sheet: .safariView(url))
                    } else {
                        toast("formulário indisponível ou inválido", .warning)
                    }

                } else {
                    isLoading = false
                    toast("formulário ainda não está disponível ou inválido", .warning)
                }

            } catch {
                isLoading = false
                print(error.localizedDescription)
            }
        }

    }
    
    func validateGoogleForm(url: URL) async -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 10
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
        } catch {
            return false
        }
        
        return false
    }
    
    func registerAdoption() {
        guard let animalId = animal.id else { return }
        navigator.navigate(to: .registerAdoption(animalId))
    }
}
