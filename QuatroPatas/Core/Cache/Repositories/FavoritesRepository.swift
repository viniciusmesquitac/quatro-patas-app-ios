//
//  FavoritesRepository.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/09/25.
//

import Foundation

final class FavoritesRepository {
    private let storage: UserDefaultsProvider
    private let favoritesKey = "favorite_animals"
    
    init(storage: UserDefaultsProvider = UserDefaultsProvider()) {
        self.storage = storage
    }
    
    func getFavorites() -> [String] {
        guard let data = storage.get(key: favoritesKey) as? Data else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
    
    func isFavorite(id: String) -> Bool {
        return getFavorites().contains(id)
    }
    
    func addFavorite(id: String) {
        var favorites = getFavorites()
        guard !favorites.contains(id) else { return }
        favorites.append(id)
        save(favorites)
    }
    
    func removeFavorite(id: String) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == id }
        save(favorites)
    }
    
    private func save(_ favorites: [String]) {
        if let data = try? JSONEncoder().encode(favorites) {
            try? storage.save(data, for: favoritesKey)
        }
    }
}
