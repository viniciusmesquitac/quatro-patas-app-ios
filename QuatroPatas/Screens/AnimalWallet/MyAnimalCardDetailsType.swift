//
//  MyAnimalCardDetailsType.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/12/25.
//


enum MyAnimalCardDetailsType: CaseIterable {
    case vaccine
    case medicine
    case weight
    case notes
}

extension MyAnimalCardDetailsType {
    var title: String {
        switch self {
        case .vaccine: "Vacinas"
        case .medicine: "Medicamentos"
        case .weight: "Peso"
        case .notes: "Anotações"
        }
    }
}