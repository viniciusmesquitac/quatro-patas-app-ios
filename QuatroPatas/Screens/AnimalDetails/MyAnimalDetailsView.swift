//
//  MyAnimalDetailsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

enum AnimalDetailsSegment: String, CaseIterable, Identifiable {
    case sheet = "Ficha"
    case data = "Dados"

    var id: String { self.rawValue }
}

struct MyAnimalDetailsView: View {
    
    @EnvironmentObject var navigator: Navigator
    @CacheProvider(type: .fileManager) var cacheProvider

    @EnvironmentObject var firebase: FirestoreProvider
    @EnvironmentObject var userSession: UserSession

    @State private var animal: Animal
    @State private var isAdopted: Bool
    
    let columns = [
        GridItem(.flexible(), spacing: Spacing.large.rawValue),
        GridItem(.flexible(), spacing: Spacing.large.rawValue)
    ]
    
    @State private var selectedSegment: AnimalDetailsSegment = .sheet
    
    
    init(animal: Animal) {
        self._animal = State(initialValue: animal)
        self._isAdopted = State(initialValue: animal.isAdopted)
    }

    private var cards: [MenuCard] {
        if let userId = userSession.user?.id, let animalId = animal.id {
            return AnimalDetailsCardFactory(animalId: animalId, userId: userId).allCases(
                navigator: navigator
            )
        }
        return []
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
            
            // Segment Control
            Picker("Segment", selection: $selectedSegment) {
                ForEach(AnimalDetailsSegment.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)

            
            switch selectedSegment {
            case .sheet:
                information
            case .data:
                cardsView
            @unknown default:
                EmptyView()
            }

        }
        .navigationBarBackButtonHidden()
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbarItem(label: "Editar", placement: .topBarTrailing) {
            navigator.navigate(to: .edit(animal.localized))
        }
    }
    
    var information: some View {
        VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
            Row(label: "Idade", value: AgeHelper.formatAge(from: animal.age))
            Row(label: "Gênero", value: animal.gender)
            Row(label: "Tipo", value: animal.type)
            Row(label: "Raça", value: animal.breed)
            Row(label: "Cor", value: animal.color)
            Row(label: "Porte", value: animal.size)
            
            if !animal.tags.isEmpty {
                Row(label: "Características", value: animal.tags.joined(separator: ", "))
            }
            
            if let status = animal.status {
                Row(label: "Status", value: status)
            }
            
            HStack {
                Text("Adotado")
                    .font(.headline)
                Spacer()
                Toggle(String(), isOn: $isAdopted)
                    .labelsHidden()
            }
            .onChange(of: isAdopted) { _, newValue in
                Task {
                    await updateAdoptionStatus(isAdopted: newValue)
                }
            }
            
            if isAdopted {
                Button {
                    guard let animalId = animal.id else { return }
                    navigator.navigate(to: .adoptionDetails(animalId))
                } label: {
                    Text("Mais Informações")
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
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
    }
    
    var cardsView: some View {
        LazyVGrid(columns: columns, spacing: Spacing.xLarge.rawValue) {
            ForEach(cards, id: \.title) { card in
                CardView(title: card.title, icon: card.icon) {
                    card.action()
                }
                .transition(card.transition ?? .identity)
            }
        }
        .padding()
    }
    
    
    @ViewBuilder
    func Row(label: String, value: String) -> some View {
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
    
    func animalPathBuilder() -> String? {
        let userId = userSession.user?.id ?? ""
        let userType = userSession.user?.type ?? .anonymous
        
        switch userType {
        case .volunteer:
            return "animals"
        case .adopter:
            return "users/\(userId)/animals"
        default:
            return nil
        }
    }
    
    private func updateAdoptionStatus(isAdopted: Bool) async {
        do {
            guard let path = animalPathBuilder() else {
                throw EditAnimalError.pathError
            }
            var copy = animal.deslocalized
            copy.isAdopted = isAdopted
            _ = try await firebase.update(copy, in: path, withID: animal.id!)
        } catch {
            print(error.localizedDescription)
        }
    }
}
