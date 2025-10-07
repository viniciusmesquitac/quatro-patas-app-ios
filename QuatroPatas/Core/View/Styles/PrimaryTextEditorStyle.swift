//
//  PrimaryTextEditorStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/10/25.
//

import SwiftUI
struct PrimaryTextEditorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.15)) // 👈 agora o cinza aparece
            .cornerRadius(CornerRadius.large.rawValue)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            .foregroundColor(.primary)
            .font(.body)
            .textInputAutocapitalization(.none)
    }
}

extension View {
    func primaryTextEditorStyle() -> some View {
        modifier(PrimaryTextEditorStyle())
    }
}
