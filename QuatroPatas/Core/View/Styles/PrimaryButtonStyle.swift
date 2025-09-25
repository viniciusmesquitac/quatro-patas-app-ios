//
//  PrimaryButtonStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/08/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = .primaryColor
    var cornerRadius: CGFloat = CornerRadius.large.rawValue
    var isLoading: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(backgroundColor.opacity(configuration.isPressed ? 0.8 : 1))
                    .cornerRadius(cornerRadius)
            } else {
                configuration.label
                    .frame(maxWidth: .infinity)
                    .padding()
                    .disabled(isLoading)
                    .background(backgroundColor.opacity(configuration.isPressed ? 0.8 : 1))
                    .foregroundColor(.customBackground)
                    .cornerRadius(cornerRadius)
                    .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
                    .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            }
        }
    }
}
