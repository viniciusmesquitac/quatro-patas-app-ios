//
//  CircleTranslucentButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

import SwiftUI

struct CircleTranslucentButtonStyle: ButtonStyle {
    var shadowColor: Color = .black.opacity(0.2)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(6)
            .background(
                Color.black
                .blur(radius: 8)
            )
            .clipShape(Circle())
            .shadow(color: .white.opacity(0.95), radius: 2, x: 0, y: 0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
