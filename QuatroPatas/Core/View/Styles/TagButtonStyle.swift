//
//  TagButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 10/10/25.
//

import SwiftUI

struct TagButtonStyle: ButtonStyle {
    
    var backgroundColor: Color = Color.primaryColor.opacity(0.2)
    var foregroundColor: Color = .primary
    var font: Font = .body
    var horizontalPadding: CGFloat = Padding.large.rawValue
    var verticalPadding: CGFloat = Padding.medium.rawValue
    var isLoading: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(foregroundColor)
            } else {
                configuration.label
                    .font(font)
                    .foregroundColor(foregroundColor)
            }
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .background(
            backgroundColor
                .opacity(configuration.isPressed ? 0.4 : 1.0)
        )
        .clipShape(Capsule())
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
