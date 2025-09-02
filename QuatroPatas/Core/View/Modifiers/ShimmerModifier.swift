//
//  ShimmerModifier.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    
    
    @State private var startPoint: UnitPoint = .init(x: -2.0, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: .zero, y: -0.25)

    
    private let gradient = [
        Color(UIColor.systemGray5),
        Color(UIColor.systemGray6),
        Color(UIColor.systemGray5)
    ]
    
    
    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(colors: gradient, startPoint: startPoint, endPoint: endPoint)
                    .mask(content)
                    .task { @MainActor in
                        startPoint = .init(x: 1, y: 1)
                        endPoint = .init(x: 2.15, y: 2.15)
                    }
                    .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: startPoint)
            }
    }
}
