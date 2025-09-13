//
//  OutlineRoundedButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 11/09/25.
//

import SwiftUI

struct OutlineRoundedButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.customBackground)
            .cornerRadius(CornerRadius.large.rawValue)
            .foregroundStyle(Color.customLabel)
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(Color.gray, lineWidth: 1)
                    .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
                    .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            )
    }
}
