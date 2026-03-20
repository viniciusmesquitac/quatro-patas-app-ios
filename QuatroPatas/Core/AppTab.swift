//  AppTab.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

enum AppTab: String {
    case adopt = "Adote"
    case myAnimals = "Meus Animais"
    case ngos = "Ongs"
    case profile = "Perfil"

    var icon: SFIcon {
        switch self {
        case .adopt: return .tab_adopt
        case .myAnimals: return .tab_myAnimals
        case .ngos: return .tab_ngo
        case .profile: return .tab_profile
        }
    }

    var selectedIcon: SFIcon {
        switch self {
        case .adopt: return .tab_adopt_filled
        case .myAnimals: return .tab_myAnimals_filled
        case .ngos: return .tab_ngo_filled
        case .profile: return .tab_profile_filled
        }
    }
}
