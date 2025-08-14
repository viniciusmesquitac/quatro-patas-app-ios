//
//  View+Modifiers.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

extension View {
    func backButton(label: String? = "", data: Any? = nil) -> some View {
        self.modifier(BackButtonToolbarModifier(label: label, data: data))
    }
}
