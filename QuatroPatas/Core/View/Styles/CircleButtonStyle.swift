//
//  CircleButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/08/25.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color.primaryColor
    var foregroundColor: Color = .black
    var size: CGFloat = 32
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .frame(width: size * 2, height: size * 2)
            .background(backgroundColor)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
