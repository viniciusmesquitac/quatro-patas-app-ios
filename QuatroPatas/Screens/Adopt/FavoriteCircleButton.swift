//
//  FavoriteCircleButton.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/03/26.
//


import SwiftUI

struct FavoriteCircleButton: View {

    var animalId: String
    let repository = FavoritesRepository()
    
    @Environment(\.toast) var toast
    
    @State var isFavorite: Bool = false

    var body: some View {
        Button(action: {
            toggleFavorite()
        }) {
            SFIcon.image(isFavorite ? .heart_filled: .heart)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
        }
        .onAppear {
            isFavorite = repository.isFavorite(id: animalId)
        }
        .buttonStyle(.plain)
    }
    
    private func toggleFavorite() {
        if isFavorite {
            repository.removeFavorite(id: animalId)
        } else {
            repository.addFavorite(id: animalId)
            toast("Adicionado aos favoritos!", .success)
        }
        isFavorite.toggle()
    }
}
