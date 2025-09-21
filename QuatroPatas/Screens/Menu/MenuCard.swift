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
}

enum MenuCardType: CaseIterable {
    case login
    case addOngAnimal
    case addMyAnimal
    case animalsList
    case adoptionForm
    case aboutShelter
    case favorites
    case myAnimals
}

extension MenuCardType {
    var title: String {
        switch self {
        case .login: return "Fazer Login"
        case .addOngAnimal: return "Adicionar Animal"
        case .addMyAnimal: return "Adicionar Animal"
        case .animalsList: return "Animais da ONG"
        case .adoptionForm: return "Formulário de Adoção"
        case .aboutShelter: return "Quem Somos"
        case .favorites: return "Meus Favoritos"
        case .myAnimals: return "Meus Animais"
        }
    }
}

// Mapa de permissões
private let allowedCardsByUserType: [UserType: [MenuCardType]] = [
    .anonymous: [.login, .adoptionForm, .aboutShelter],
    .volunteer: [.addOngAnimal, .animalsList, .aboutShelter],
    .adopter: [.adoptionForm, .aboutShelter, .favorites, .myAnimals],
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
                    userSession.isLoggedIn = false
                    userSession.user = nil
                    navigator.popToRoot()
                })

            case .addOngAnimal:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .addAnimal(.ongAnimals))
                }, icon: .add)

            case .animalsList:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .animalsList(.allAnimals))
                })

            case .adoptionForm:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .adoptionForm)
                }, icon: .form)

            case .aboutShelter:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .webView(URL(string: "https://4patasfortaleza.org")!))
                }, icon: .about)

            case .favorites:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .animalsList(.favorites))
                }, icon: .favorite)
            case .myAnimals:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .animalsList(.myAnimals))
                })
            case .addMyAnimal:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .addAnimal(.myAnimals))
                }, icon: .add)
            }
        }
    }
}
