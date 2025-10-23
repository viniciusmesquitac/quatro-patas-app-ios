//
//  BackButtonModifier.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct ToolbarItemModifier: ViewModifier {
    @EnvironmentObject var navigator: Navigator
    var label: String?
    var icon: SFIcon?
    var color: Color
    var placement: ToolbarItemPlacement
    var action: (() -> Void)
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: placement) {
                    if let icon = icon {
                        Button(label ?? String(), systemImage: icon.rawValue) {
                            action()
                        }
                        .tint(color)
                        .foregroundStyle(color)
                    } else {
                        Button(label ?? String()) {
                            action()
                        }
                        .tint(color)
                        .foregroundStyle(color)
                    }
                }
            }
    }
}

extension View {
    func toolbarItem(label: String? = "", icon: SFIcon? = nil, color: Color = Color.primaryColor, placement: ToolbarItemPlacement = .automatic, action: @escaping () -> Void) -> some View {
        self.modifier(ToolbarItemModifier(label: label, icon: icon, color: color, placement: placement, action: action))
    }
}

