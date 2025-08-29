//
//  ToolbarMenuModifier.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI

struct ToolbarMenuModifier: ViewModifier {
    var label: String?
    var icon: SFIcon
    var placement: ToolbarItemPlacement
    var actions: [ToolbarMenuAction]
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: placement) {
                    Menu {
                        ForEach(actions) { action in
                            Button(action: action.action) {
                                Label(action.label, systemImage: action.icon.rawValue)
                            }
                        }
                    } label: {
                        HStack {
                            SFIcon.image(icon)
                            if let label = label {
                                Text(label)
                            }
                        }
                    }
                }
            }
    }
}

/// Modelo para cada ação do menu
struct ToolbarMenuAction: Identifiable {
    let id = UUID()
    let label: String
    let icon: SFIcon
    let action: () -> Void
}

extension View {
    func toolbarMenu(
        label: String? = "",
        icon: SFIcon,
        placement: ToolbarItemPlacement = .automatic,
        actions: [ToolbarMenuAction]
    ) -> some View {
        self.modifier(
            ToolbarMenuModifier(label: label, icon: icon, placement: placement, actions: actions)
        )
    }
}
