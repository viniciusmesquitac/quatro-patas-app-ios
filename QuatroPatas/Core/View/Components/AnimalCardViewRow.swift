//
//  AnimalCardViewRow.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/09/25.
//

import SwiftUI

struct AnimalCardViewRow: View {
    let animal: Animal
    let action: () -> Void
    
    @CacheProvider(type: .fileManager)
    var cacheProvider
    
    private enum Constants {
        static let imageSize: CGFloat = 70
        static let cornerRadius: CGFloat = 8
        static let nameFontSize: CGFloat = 18
        static let ageFontSize: CGFloat = 14
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.large.rawValue) {
                // Imagem do animal
                if let firstURL = animal.photos.first, let url = URL(string: firstURL) {
                    
                    if let imageData = cacheProvider.get(key: getToken(url: url)) as? Data,
                       let uii = UIImage(data: imageData) {
                        Image(uiImage: uii)
                            .resizable()
                            .scaledToFill()
                            .frame(width: Constants.imageSize, height: Constants.imageSize)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    } else {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                                    .modifier(ShimmerModifier())
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                                    .onAppear { saveImageData(url: url) }
                            default:
                                Image("default-animal-card.png")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: Constants.imageSize, height: Constants.imageSize)
                                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                            }
                        }
                    }
                } else {
                    Image("default-animal-card.png")
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
                
                VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                    HStack {
                        Text(animal.name)
                            .font(.system(size: Constants.nameFontSize, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        if animal.isAdopted {
                            Spacer()
                            Text("Adotado")
                                .font(.system(size: 12, weight: .bold))
                                .padding(.horizontal, Padding.medium.rawValue)
                                .padding(.vertical, Padding.small.rawValue)
                                .background(Color.primaryColor)
                                .foregroundColor(.customBackground)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text(DateHelper.formatCreatedAt(animal.createdAt))
                        .font(.system(size: Constants.ageFontSize))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(NoneButtonStyle())
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
