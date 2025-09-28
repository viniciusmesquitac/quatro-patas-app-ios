//
//  SelectionRowButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/09/25.
//

import SwiftUI

struct SelectionRowButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                (isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
                    .cornerRadius(8)
            )
            .contentShape(Rectangle()) // área de toque inteira
            .opacity(configuration.isPressed ? 0.7 : 1.0) // feedback ao toque
    }
}
