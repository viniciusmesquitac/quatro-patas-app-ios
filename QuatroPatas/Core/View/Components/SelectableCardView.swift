//
//  SelectableCardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/10/25.
//

import SwiftUI

struct SelectableCardView: View {
    var title: String
    var icon: SFIcon? = nil
    @Binding var selection: String
    var questionId: String
    var formManager: FormManager

    var body: some View {
        Button(action: {
            selection = title
            formManager.errors.remove(questionId)
        }) {
            ZStack {
                // Fundo muda conforme selecionado
                (selection == title ? Color.primaryColor.opacity(0.15) : Color.customBackground)
                    .cornerRadius(CornerRadius.medium.rawValue)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        if let icon = icon?.rawValue {
                            Image(systemName: icon)
                                .font(.system(size: 22))
                                .foregroundStyle(selection == title ? Color.primaryColor : Color.secondary)
                        }
                        Spacer()
                        Image(systemName: selection == title ? SFIcon.circle_filled.rawValue : SFIcon.circle.rawValue)
                            .foregroundStyle(selection == title ? Color.primaryColor : Color.secondary)
                    }

                    Spacer()

                    Text(title)
                        .foregroundStyle(Color.customLabel)
                        .font(.headline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
            .frame(maxWidth: .infinity, minHeight: 100)
        }
        .buttonStyle(CardButtonStyle())
    }
}
