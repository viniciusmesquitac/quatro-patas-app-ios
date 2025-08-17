//
//  View+Modifiers.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

extension View {
    func toolbarItem(label: String? = "", icon: SFIcon, placement: ToolbarItemPlacement = .automatic, action: @escaping () -> Void) -> some View {
        self.modifier(ToolbarItemModifier(label: label, icon: icon, placement: placement, action: action))
    }
}
