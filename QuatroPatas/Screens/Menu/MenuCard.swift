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
    case addOngAnimal
    case addMyAnimal
    case ongAnimalsList
    case adoptionForm
    case aboutShelter
    case favorites
    case myAnimals
    case lostAnimal
    case apoiase
}

extension MenuCardType {
    var title: String {
        switch self {
        case .login: return "Fazer Login"
        case .addOngAnimal: return "Adicionar Animal"
        case .addMyAnimal: return "Adicionar Animal"
        case .ongAnimalsList: return "Animais"
        case .adoptionForm: return "Formulário de Adoção"
        case .aboutShelter: return "Quem Somos"
        case .favorites: return "Meus Favoritos"
        case .myAnimals: return "Meus Animais"
        case .lostAnimal: return "Animal Perdido"
        case .apoiase: return "Apoia-se"
        }
    }
}

// Mapa de permissões
private let allowedCardsByUserType: [UserType: [MenuCardType]] = [
    .ngo: [
        .addOngAnimal, .ongAnimalsList
    ],
    .adopter: [
        .adoptionForm, .aboutShelter, .favorites, .apoiase, .lostAnimal, .myAnimals
    ],
    .anonymous: [
        .adoptionForm, .aboutShelter, .favorites, .apoiase, .lostAnimal, .myAnimals
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
                
            case .addOngAnimal:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .addAnimal)
                }, icon: .add)
                
            case .ongAnimalsList:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .animalsList(.ongAnimals))
                })
                
            case .adoptionForm:
                return MenuCard(title: cardType.title, action: {
                    if let url = URL(string: "https://forms.gle/fwbzQjBzHFxv1fLZ6") {
                        let request = URLRequest(url: url)
                        navigator.navigate(to: .webView(request))
                    }
                }, icon: .form)
                
            case .aboutShelter:
                return MenuCard(title: cardType.title, action: {
                    if let url = URL(string: "https://sites.google.com/view/4patasfortaleza/quem-somos?authuser=0") {
                        let request = URLRequest(url: url)
                        navigator.navigate(to: .webView(request))
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
                
            case .myAnimals:
                return MenuCard(title: cardType.title, action: {
                    if userSession.user?.type == .anonymous {
                        navigator.navigate(to: .login)
                    } else {
                        navigator.navigate(to: .animalsList(.myAnimals))
                    }
                })
                
            case .lostAnimal:
                return MenuCard(title: cardType.title, action: {
                    if userSession.user?.type == .anonymous {
                        navigator.navigate(to: .login)
                    } else {
                        navigator.navigate(to: .reportMissingAnimal)
                    }
                }, icon: .report)
                
            case .addMyAnimal:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .addAnimal)
                }, icon: .add)
            case .apoiase:
                return MenuCard(title: cardType.title, action: {
                    if let url = URL(string: "https://apoia.se/quatropatasfortaleza") {
                        let request = URLRequest(url: url)
                        navigator.navigate(to: .webView(request))
                    }
                }, icon: .donate, isFocused: true)
            }
        }
    }
}
