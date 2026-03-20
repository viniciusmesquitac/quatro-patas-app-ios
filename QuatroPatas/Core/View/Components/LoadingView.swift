//
//  LoadingView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 4)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 4,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(Color.primaryColor)
                    .rotationEffect(.degrees(rotation))
                    .animation(
                        .linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: rotation
                    )
                    .onAppear {
                        rotation = 360
                    }
            }
            .frame(width: 64, height: 64)
        }
    }
}
