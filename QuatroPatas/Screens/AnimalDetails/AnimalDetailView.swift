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
    @State private var owner: User?

    let repository = FavoritesRepository()
    
    var colorNavBar: Color {
        colorScheme == .dark ? Color(UIColor.goldenYellow) : Color(UIColor.magicYellow)
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder
    var imageGallery: some View {
        let imageUrls = animal.photos.compactMap { URL(string: $0) }
        
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                // Main image carousel
                TabView(selection: $selectedImageIndex) {
                    ForEach(imageUrls.indices, id: \.self) { index in
                        GeometryReader { proxy in
                            CachedAsyncImage(url: imageUrls[index])
                                .aspectRatio(contentMode: .fill)
                                .frame(width: proxy.size.width, height: 400)
                                .clipped()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 400)
                .onTapGesture {
                    showFullScreen = true
                }
                
                // Overlays
                
                // Top Action Bar
                VStack {
                    HStack {
                        // Back Button
                        Button(action: {
                            navigator.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                                .frame(width: 40, height: 40)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        
                        Spacer()
                        
                        // Action buttons
                        HStack(spacing: 8) {
                            Button(action: {
                                shareAnimal()
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                                    .frame(width: 40, height: 40)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                            
                            Button(action: {
                                toggleFavorite()
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(isFavorite ? .red : .primary)
                                    .frame(width: 40, height: 40)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                        }
                    }
                    .padding(.horizontal, Padding.large.rawValue)
                    .padding(.top, Padding.xxLarge.rawValue + Padding.xLarge.rawValue) // Account for safe area
                    
                    Spacer()
                }
                
                // Counter
                if imageUrls.count > 1 {
                    Text("\(selectedImageIndex + 1) / \(imageUrls.count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, Padding.large.rawValue)
                        .padding(.vertical, Padding.medium.rawValue)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.top, Padding.xxLarge.rawValue * 2)
                }
                
                // Navigation Chevrons
                if imageUrls.count > 1 {
                    HStack {
                        Button(action: {
                            withAnimation { selectedImageIndex = max(0, selectedImageIndex - 1) }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .opacity(selectedImageIndex > 0 ? 1 : 0)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation { selectedImageIndex = min(imageUrls.count - 1, selectedImageIndex + 1) }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.primary)
                                .frame(width: 36, height: 36)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .opacity(selectedImageIndex < imageUrls.count - 1 ? 1 : 0)
                    }
                    .padding(.horizontal, Padding.large.rawValue)
                    .padding(.top, 182) // Roughly centered vertically in a 400pt frame
                }
            }
            
            // Thumbnails
            if imageUrls.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(imageUrls.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation { selectedImageIndex = index }
                            }) {
                                CachedAsyncImage(url: imageUrls[index])
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedImageIndex == index ? colorNavBar : Color.clear, lineWidth: 2)
                                    )
                                    .opacity(selectedImageIndex == index ? 1.0 : 0.6)
                            }
                        }
                    }
                    .padding(.horizontal, Padding.large.rawValue)
                    .padding(.vertical, Padding.large.rawValue)
                }
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: Spacing.small.rawValue) {
                    
                    imageGallery

                    // conteúdo abaixo da imagem
                    VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {

                        Text(animal.name + ", " + animal.ageFormatted)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        TagsView(tags: loadTags())

                        Text(animal.description)
                            .padding(.top, Padding.large.rawValue)
                            
                        if let owner = owner {
                            VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                                Text("Responsável")
                                    .font(.headline)
                                
                                HStack(spacing: 12) {
                                    if let photo = owner.photo, let url = URL(string: photo) {
                                        CachedAsyncImage(url: url)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(owner.name)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        if let location = owner.location {
                                            Text(location)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(Padding.large.rawValue)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                            .padding(.top, Padding.medium.rawValue)
                        }

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
                    .padding(Padding.large.rawValue)
                }
            }.ignoresSafeArea(edges: .top)
        }
        .environmentObject(navigator)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            isFavorite = repository.isFavorite(id: animal.id ?? String())
            fetchOwner()
        }
    }
    
    func loadTags() -> [TagItem] {
        animal.tags
            .compactMap { AnimalTag(rawValue: $0) }
            .map { $0.makeTagItem(using: navigator) }
    }
    
    private func fetchOwner() {
        guard let ownerId = animal.ownerId else { return }
        Task {
            do {
                let user: User? = try await databaseProvider.fetchDocument(from: "users", id: ownerId)
                await MainActor.run {
                    self.owner = user
                }
            } catch {
                print("Failed to fetch owner: \(error.localizedDescription)")
            }
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



import SwiftUI

struct StatusBarStyleController: UIViewControllerRepresentable {
    let style: UIStatusBarStyle

    func makeUIViewController(context: Context) -> UIViewController {
        Controller(style: style)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        (uiViewController as? Controller)?.style = style
        uiViewController.setNeedsStatusBarAppearanceUpdate()
    }

    final class Controller: UIViewController {
        var style: UIStatusBarStyle

        init(style: UIStatusBarStyle) {
            self.style = style
            super.init(nibName: nil, bundle: nil)
            view.backgroundColor = .clear
        }

        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        override var preferredStatusBarStyle: UIStatusBarStyle {
            style
        }
    }
}

extension View {
    /// Força o estilo da Status Bar sem mexer no colorScheme da tela toda.
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        background(StatusBarStyleController(style: style).frame(width: 0, height: 0))
    }
}
