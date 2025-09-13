//
//  FloatingButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//


import SwiftUI

struct FloatingButtonStyle: ButtonStyle {
    var background: AnyShapeStyle = AnyShapeStyle(.ultraThinMaterial)
    var foreground: Color = .yellow
    var shadowColor: Color = .black.opacity(0.2)
    var shape: some InsettableShape = Circle()
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foreground)
            .padding()
            .background(background)
            .clipShape(shape)
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // feedback ao toque
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
