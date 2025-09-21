//
//  DetailCardFactory.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

enum MyAnimalCardDetailsType: CaseIterable {
    case vacine
    case medicine
    case weight
    case notes
}

extension MyAnimalCardDetailsType {
    var title: String {
        switch self {
        case .vacine: "Vacinas"
        case .medicine: "Medicamentos"
        case .weight: "Peso"
        case .notes: "Anotações"
        }
    }
}

struct AnimalDetailsCardFactory {
    
    @MainActor
    func allCases(navigator: Navigator) -> [MenuCard] {
        return MyAnimalCardDetailsType.allCases.map { cardType in
            switch cardType {
            case .vacine:
                return MenuCard(title: cardType.title, action: {
                    navigator.popToRoot()
                })
                
            case .medicine:
                return MenuCard(title: cardType.title, action: {
                    navigator.popToRoot()
                })
                
            case .weight:
                return MenuCard(title: cardType.title, action: {
                    navigator.popToRoot()
                })
            case .notes:
                return MenuCard(title: cardType.title, action: {
                    navigator.popToRoot()
                })
            }
        }
    }
}
