//
//  DotsLoader.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/09/25.
//


import SwiftUI

struct DotsLoader: View {
    @State private var scales: [CGFloat] = [1, 1, 1]
    
    let dotCount = 3
    let size: CGFloat = 8
    let spacing: CGFloat = 12
    let duration: Double = 0.3
    let maxScale: CGFloat = 1.6

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(Color.primaryColor)
                    .frame(width: size, height: size)
                    .scaleEffect(scales[index])
                    .animation(
                        Animation.easeInOut(duration: duration)
                            .repeatForever()
                            .delay(Double(index) * duration / 2),
                        value: scales[index]
                    )
            }
        }
        .onAppear {
            for i in 0..<dotCount {
                scales[i] = maxScale
            }
        }
    }
}

struct DotsLoader_Previews: PreviewProvider {
    static var previews: some View {
        DotsLoader()
    }
}
