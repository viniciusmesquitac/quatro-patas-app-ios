//
//  SelectableButton.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/09/25.
//

import SwiftUI

struct SelectableButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .frame(maxWidth: .infinity, minHeight: 50) // garante metade da largura
                .background(isSelected ? Color.primaryColor.opacity(0.2) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .secundaryColor : .primary)
                .cornerRadius(12)
        }
        .buttonStyle(FilterButtonStyle())
    }
}
