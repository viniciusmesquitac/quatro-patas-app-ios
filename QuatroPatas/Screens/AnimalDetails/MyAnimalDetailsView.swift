//
//  MyAnimalDetailsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI


struct MyAnimalDetailsView: View {
    
    @EnvironmentObject var navigator: Navigator
    @CacheProvider(type: .fileManager)
    var cacheProvider

    @State var animal: Animal
    
    let columns = [
        GridItem(.flexible(), spacing: Spacing.large.rawValue),
        GridItem(.flexible(), spacing: Spacing.large.rawValue)
    ]

    private var cards: [MenuCard] {
        return AnimalDetailsCardFactory().allCases(
            navigator: navigator
        )
    }

    var body: some View {
        ScrollView {
            // Foto
            if let firstURL = animal.photos.first,
               let url =  URL(string: firstURL),
               let imageData = cacheProvider.get(key: getToken(url: url)) as? Data,
               let uii = UIImage(data: imageData) {
                Image(uiImage: uii)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())
                    .shadow(radius: 4)
                    .padding(.top)
            }

            // Nome
            Text(animal.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, Padding.medium.rawValue)

            // Informações principais
            VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
                infoRow(label: "Idade", value: AgeHelper.formatAge(from: animal.age))
                infoRow(label: "Gênero", value: animal.gender)
                infoRow(label: "Tipo", value: animal.type)
                infoRow(label: "Raça", value: animal.breed)
                infoRow(label: "Cor", value: animal.color)
                infoRow(label: "Porte", value: animal.size)
                
                if !animal.tags.isEmpty {
                    infoRow(label: "Características", value: animal.tags.joined(separator: ", "))
                }
                
                if let status = animal.status {
                    infoRow(label: "Status", value: status)
                }
                
                if !animal.description.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                        Text("Descrição")
                            .font(.headline)
                        Text(animal.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, Padding.medium.rawValue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue)
                    .fill(Color(.systemBackground))
                    .stroke(Color.gray.opacity(0.2), style: .init(lineWidth: 1))
            )
            .padding(.horizontal)


            LazyVGrid(columns: columns, spacing: Spacing.xLarge.rawValue) {
                ForEach(cards, id: \.title) { card in
                    CardView(title: card.title, icon: card.icon) {
                        card.action()
                    }
                    .transition(card.transition ?? .identity)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbarItem(label: "Editar", placement: .topBarTrailing) {
            navigator.navigate(to: .edit(animal.localized))
        }
    }
    
    
    @ViewBuilder
    func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .font(.body)
        Divider()
    }
    
    func getToken(url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
                  return url.absoluteString
              }
        return token
    }
}
