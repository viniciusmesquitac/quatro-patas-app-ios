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
    var uploadProgress: Double
    
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

                ProgressView(value: uploadProgress)
                    .progressViewStyle(.linear)
                    .frame(maxWidth: 140)
                    .tint(.primaryColor)
                    .scaleEffect(x: 1, y: 1.2, anchor: .center)
                    .animation(.easeInOut(duration: 0.3), value: uploadProgress)

                Text("\(Int(round(uploadProgress * 100)))%")
                    .font(.footnote)
                    .foregroundColor(.customLabel.opacity(0.9))
                    .animation(.easeInOut(duration: 0.3), value: uploadProgress)
            }
            .padding()
            .animation(.easeInOut, value: currentUploadIndex)
        }.ignoresSafeArea()
    }
}
