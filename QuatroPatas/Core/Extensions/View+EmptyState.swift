//
//  View+EmptyState.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 04/10/25.
//

import SwiftUI

enum EmptyStateType {
    case search
    case cat
    case vaccine
    case generic(name: String, message: String, title: String)
    
    var config: (name: String, message: String, title: String) {
        switch self {
        case .search:
            return (
                name: "empty_search",
                message: "Nenhum resultado encontrado.",
                title: "Adicionar"
            )
            
        case .cat:
            return (
                name: "cat_in_box",
                message: "Hmmm... \nNão tem nada por aqui!",
                title: "Buscar todos"
            )
            
        case .vaccine:
            return (
                name: "vaccine",
                message: "Nenhum resultado encontrado.",
                title: "Adicionar vacina"
            )
            
        case let .generic(name, message, title):
            return (name: name, message: message, title: title)
        }
    }
}

extension View {
    func emptyState(
        _ type: EmptyStateType,
        action: (() -> Void)? = nil
    ) -> some View {
        let config = type.config
        
        return ScrollView {
            VStack(spacing: Spacing.large.rawValue) {
                LottieView(name: config.name, loopMode: .loop)
                    .frame(width: 200, height: 200)
                
                Text(config.message)
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                if let action = action {
                    Button(config.title, action: action)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 40)
            .transition(.opacity)
        }
    }
}
