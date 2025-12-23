//
//  DetailCardFactory.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

struct AnimalDetailsCardFactory {
    
    var animalId: String
    var userId: String
    
    @MainActor
    func allCases(navigator: Navigator) -> [MenuCard] {
        return MyAnimalCardDetailsType.allCases.map { cardType in
            switch cardType {
            case .vaccine:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .vaccineList(animalId))
                }, icon: .vaccine)
                
            case .medicine:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .medicationList(animalId))
                }, icon: .medicine)
                
            case .weight:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .weightChart(animalId))
                }, icon: .weight)
            case .notes:
                return MenuCard(title: cardType.title, action: {
                    navigator.navigate(to: .annotationList(animalId))
                }, icon: .annotation)
            }
        }
    }
}
