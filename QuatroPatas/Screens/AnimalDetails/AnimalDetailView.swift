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
    
    @State private var selectedImageIndex = 0
    @State private var showFullScreen = false
    @State private var isFavorite = false

    let repository = FavoritesRepository()
    
    
    var image: some View {
        ZStack(alignment: .bottom) {
            ImageCarousel(
                images: animal.photos.compactMap { URL(string: $0) },
                selectedIndex: $selectedImageIndex
            )
            .stretchy()
            .onTapGesture {
                showFullScreen = true
            }
        }
        .background(Color(uiColor: .systemBackground))
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
                            Text(userSession.user?.type == .ngo ? "Cadastrar adoção" : "Adotar")
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
                    SFIcon.image(.back, color: .primaryColor)
                }
                .buttonStyle(FloatingButtonStyle())
                
                Spacer()
                
                Button {
                    shareAnimal()
                } label: {
                    SFIcon.image(.share, color: .primaryColor)
                }
                .buttonStyle(FloatingButtonStyle())
            }.padding(.horizontal)
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
                    openForms()
                })
        ))
    }
    
    func openForms() {
        guard let ownerId = animal.ownerId else {
            navigator.dismiss()
            toast("formulário ainda não está dispónivel", .warning)
            return
        }
        Task {
            do {
                let user: User? = try await databaseProvider.fetchDocument(from: "users", id: ownerId)
                navigator.dismiss()
                
                let validGoogleFormsHosts = ["forms.gle", "docs.google.com"]

                if
                    let form = user?.form,
                    let url = URL(string: form),
                    let host = url.host,
                    validGoogleFormsHosts.contains(host)
                {
                    // 🔎 2ª verificação: de fato existe online
                    let isValid = await validateGoogleForm(url: url)

                    if isValid {
                        let request = URLRequest(url: url)
                        navigator.navigate(to: .webView(request))
                    } else {
                        toast("formulário indisponível ou inválido", .warning)
                    }

                } else {
                    toast("formulário ainda não está disponível ou inválido", .warning)
                }

            } catch {
                print(error.localizedDescription)
            }
        }

    }
    
    func validateGoogleForm(url: URL) async -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // mais leve que GET
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
        navigator.present(sheet: .tip(
            Tip(title: Tip.registerAdoption.title,
                description: Tip.registerAdoption.description,
                buttonText: "Tudo certo!",
                buttonAction: {
                    guard let animalId = animal.id else { return }
                    navigator.dismiss()
                    navigator.navigate(to: .registerAdoption(animalId))
                })
        ))
    }
}
