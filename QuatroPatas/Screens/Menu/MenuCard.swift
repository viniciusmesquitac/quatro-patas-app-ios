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
    let transition: AnyTransition? = .scale.combined(with: .opacity)
}

enum MenuCardType: CaseIterable {
    case login
    case addAnimal
    case animalsList
    case adoptionForm
    case aboutShelter
    case logout
    case favorites
    case myAnimals
}

extension MenuCardType {
    var title: String {
        switch self {
        case .login: return "Fazer Login"
        case .addAnimal: return "Adicionar Animal"
        case .animalsList: return "Animais da ONG"
        case .adoptionForm: return "Formulário de Adoção"
        case .aboutShelter: return "Sobre o abrigo"
        case .logout: return "Sair"
        case .favorites: return "Meus Favoritos"
        case .myAnimals: return "Meus Animais"
        }
    }
}

// Mapa de permissões
private let allowedCardsByUserType: [UserType: [MenuCardType]] = [
    .anonymous: [.login, .adoptionForm, .aboutShelter],
    .admin: [.addAnimal, .animalsList, .adoptionForm, .aboutShelter, .logout],
    .adopter: [.adoptionForm, .aboutShelter, .logout, .favorites],
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

            case .addAnimal:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .addAnimal)
                })

            case .animalsList:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .animalsList(.allAnimals))
                })

            case .adoptionForm:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .adoptionForm)
                })

            case .aboutShelter:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .webView(URL(string: "https://4patasfortaleza.org")!))
                })

            case .logout:
                return MenuCard(title: cardType.title, action: {
                    navigator.present(sheet: .logout)
                })

            case .favorites:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .animalsList(.favorites))
                })
            case .myAnimals:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .animalsList(.myAnimals))
                })
            }
        }
    }
}
