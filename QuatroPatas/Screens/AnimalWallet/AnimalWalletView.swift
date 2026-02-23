//
//  AnimalWalletView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

struct AnimalWalletView: View {
    
    @EnvironmentObject var navigator: Navigator
    @CacheProvider(type: .fileManager) var cacheProvider

    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession

    @State private var animal: Animal
    @State private var isAdoptedToggle: Bool
    @State private var isAdopted: Bool
    @State private var isMissing: Bool
    
    @State private var selectedImageIndex = 0
    @State private var showFullScreen = false

    let columns = [
        GridItem(.flexible(), spacing: Spacing.large.rawValue),
        GridItem(.flexible(), spacing: Spacing.large.rawValue)
    ]
    
    @State private var selectedSegment: AnimalWalletSegment = .sheet
    
    
    init(animal: Animal) {
        self._animal = State(initialValue: animal)
        self._isAdopted = State(initialValue: animal.isAdopted)
        self._isAdoptedToggle = State(initialValue: animal.isAdopted)
        self._isMissing = State(initialValue: animal.isMissing)
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
            if let firstURL = animal.photos.first,
               let url = URL(string: firstURL) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())
                    .padding(.top)
                    .onTapGesture {
                        showFullScreen = true
                    }
            }


            // Nome
            Text(animal.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, Padding.medium.rawValue)
            
            // Segment Control
            Picker("Segment", selection: $selectedSegment) {
                ForEach(AnimalWalletSegment.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .tint(Color.primaryColor)
            .padding(.top, Padding.medium.rawValue)

            
            switch selectedSegment {
            case .sheet:
                information
            case .health:
                cardsView
            @unknown default:
                EmptyView()
            }

        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $showFullScreen) {
            ZoomableCarouselView(images: animal.photos,
                                 selectedIndex: $selectedImageIndex)
        }
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbarItem(label: "Editar", placement: .topBarTrailing) {
            navigator.navigate(to: .edit(animal))
        }
    }
    
    var information: some View {
        VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
            Row(label: "Idade", value: animal.ageFormatted)
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
            if userSession.user?.type == .ngo {
                HStack {
                    Text("Adotado")
                        .font(.headline)
                    Spacer()
                    Toggle(String(), isOn: $isAdoptedToggle)
                        .labelsHidden()
                }.onChange(of: isAdoptedToggle) { _, newValue in
                    if newValue == true {
                        guard let animalId = animal.id else { return }
                        navigator.navigate(to: .registerAdoption(animalId))
                    } else {
                        Task {
                            await updateAdoptionStatus(isAdopted: false)
                        }
                    }
                }
                
                HStack {
                    Text("Perdido")
                        .font(.headline)
                    Spacer()
                    Toggle(String(), isOn: $isMissing)
                        .labelsHidden()
                }
                .onChange(of: isMissing) { _, newValue in
                    Task {
                        await updateMissingStatus(isMissing: newValue)
                    }
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
                        .padding(.vertical, Padding.medium.rawValue)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(CornerRadius.medium.rawValue)
                }
                .padding(.top, Padding.medium.rawValue)
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
            
            if let folder = animal.folder {
                VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                    Text("Pasta")
                        .font(.headline)
                    Text(folder)
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
    
    func animalPathBuilder() -> String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals"
    }
    
    private func updateAdoptionStatus(isAdopted: Bool) async {
        do {
            guard let path = animalPathBuilder(), let animalId = animal.id else {
                throw EditAnimalError.pathError
            }
            _ = try await databaseProvider.updateFields(
                in: path,
                id: animalId,
                fields: ["isAdopted": isAdopted]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateMissingStatus(isMissing: Bool) async {
        do {
            guard let path = animalPathBuilder(), let animalId = animal.id else {
                throw EditAnimalError.pathError
            }
            _ = try await databaseProvider.updateFields(
                in: path,
                id: animalId,
                fields: ["isMissing": isMissing]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
