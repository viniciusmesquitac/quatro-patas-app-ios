//
//  MenuCard.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/09/25.
//

import SwiftUI

struct MenuCard {
    let title: String
    let action: () -> Void
    var icon: SFIcon = .paw
    let transition: AnyTransition? = .scale.combined(with: .opacity)
    var isFocused: Bool = false
}

enum MenuCardType: CaseIterable {
    case login
    case aboutShelter
    case favorites
    case lostAnimal
}

extension MenuCardType {
    var title: String {
        switch self {
        case .login: return "Fazer Login"
        case .aboutShelter: return "Quem Somos"
        case .favorites: return "Meus Favoritos"
        case .lostAnimal: return "Animal Perdido"
        }
    }
}

// Mapa de permissões
private let allowedCardsByUserType: [UserType: [MenuCardType]] = [
    .ngo: [
        .aboutShelter, .favorites, .aboutShelter
    ],
    .adopter: [
        .aboutShelter, .favorites, .lostAnimal
    ],
    .anonymous: [
        .aboutShelter, .favorites, .lostAnimal
    ]
]

struct MenuCardFactory {
    
    @MainActor
    func allCases(for type: UserType,
                  navigator: Navigator,
                  userSession: UserSession) -> [MenuCard] {
        
        let allowedCards = allowedCardsByUserType[type] ?? []
        
        return allowedCards.map { cardType in
            switch cardType {
            case .login:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .login)
                })
                
            case .aboutShelter:
                return MenuCard(title: cardType.title, action: {
                    if let url = URL(string: "https://sites.google.com/view/4patasfortaleza/quem-somos?authuser=0") {
                        navigator.present(sheet: .safariView(url))
                    }
                }, icon: .about)
                
            case .favorites:
                return MenuCard(title: cardType.title, action: {
                    if userSession.user?.type == .anonymous {
                        navigator.navigate(to: .login)
                    } else {
                        navigator.navigate(to: .favorites)
                    }
                }, icon: .favorite)
                
            case .lostAnimal:
                return MenuCard(title: cardType.title, action: {
                    if userSession.user?.type == .anonymous {
                        navigator.navigate(to: .login)
                    } else {
                        navigator.navigate(to: .reportMissingAnimal)
                    }
                }, icon: .report)
            }
        }
    }
}
