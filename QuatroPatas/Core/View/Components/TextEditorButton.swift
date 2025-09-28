//
//  TextEditorButton.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/09/25.
//


import SwiftUI

struct TextEditorButton: View {
    @Binding var text: String
    var placeholder: String = "Adicionar descrição..."
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.secondary)
                } else {
                    Text(text)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
