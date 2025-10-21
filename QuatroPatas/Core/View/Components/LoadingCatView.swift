//
//  LoadingCatView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/10/25.
//

import SwiftUI

struct LoadingCatView: View {
    
    var size: CGFloat = 128
    var currentUploadIndex: Int
    var totalItems: Int
    
    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            VStack(spacing: Spacing.medium.rawValue) {
                LottieView(name: "cat_loading", loopMode: .loop)
                    .frame(width: size, height: size)
                
                if currentUploadIndex > 0 {
                    Text("Enviando \(currentUploadIndex)/\(totalItems)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.customLabel)
                        .transition(.opacity)
                }
            }
            .padding()
            .animation(.easeInOut, value: currentUploadIndex)
        }.ignoresSafeArea()
    }
}
