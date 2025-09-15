//
//  FloatingButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//


import SwiftUI

struct FloatingButtonStyle: ButtonStyle {
    var foreground: Color = Color.primaryColor
    var shadowColor: Color = .black.opacity(0.2)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foreground)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
