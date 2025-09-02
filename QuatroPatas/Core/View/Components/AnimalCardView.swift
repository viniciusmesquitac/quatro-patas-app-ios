//
//  AnimalCardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/07/25.
//


import SwiftUI

struct AnimalCardView: View {
    let animal: Animal
    let action: () -> Void
    
    @CacheProvider(type: .fileManager)
    var cacheProvider
    
    private enum Constants {
        // Font
        static let gradientOpacity: CGFloat = 0.6
        static let animalNameFontSize: CGFloat = 24

        // Image
        static let cornerRadius: CGFloat = 8

        // Size
        static let width: CGFloat = 155
        static let height: CGFloat = 180
    }

    private var gradient: Gradient {
        Gradient(colors: [
            Color.black.opacity(Constants.gradientOpacity),
            Color.clear
        ])
    }

    private var LinearGradientEffect: some View {
        LinearGradient(gradient: gradient,
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var AnimalNameView: some View {
        VStack {
            Spacer()
            Text(animal.name)
                .padding(.leading, 8)
                .font(.system(size: Constants.animalNameFontSize, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LinearGradientEffect)
        }
    }

    var body: some View {
        Button(action: action) {
            VStack {
                GeometryReader { geometry in
                    if let firstURL = animal.photos.first, let url = URL(string: firstURL) {
                        
                        if let imageData = cacheProvider.get(key: getToken(url: url)) as? Data, let uii = UIImage(data: imageData) {
                            Image(uiImage: uii)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .overlay {
                                    AnimalNameView
                                }
                                .cornerRadius(CornerRadius.small.rawValue)
                        } else {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue)
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .modifier(ShimmerModifier())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                        .overlay {
                                            AnimalNameView
                                        }
                                        .cornerRadius(CornerRadius.small.rawValue)
                                        .onAppear {
                                            saveImageData(url: url)
                                        }
                                default:
                                    Image("default-animal-card.png")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                                        .overlay(content: {
                                            AnimalNameView
                                        })
                                        .cornerRadius(CornerRadius.small.rawValue)
                                }
                            }
                        }

                    }
                }
            }

            .frame(width: Constants.width, height: Constants.height)
        }
        .buttonStyle(CardButtonStyle())
    }
    
    func getToken(url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
                  return url.absoluteString
              }
        return token
    }

    func saveImageData(url: URL) {
        let token = getToken(url: url)
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    try cacheProvider.save(data, for: token)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


struct AnimalCardView_Preview: PreviewProvider {

    static var previews: some View {
        AnimalCardView(animal: Animal(
            id: "0",
            name: "Priscila",
            age: "2 anos",
            gender: .female,
            type: .cat,
            breed: .mixed, color: .blackAndWhite,
            description: "Castrada, vermifugada, Vacinada"
        ), action: {})
        .previewLayout(PreviewLayout.fixed(width: 150, height: 180))
    }
}
