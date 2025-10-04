//
//  LoadingCatView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/10/25.
//

import SwiftUI

struct LoadingCatView: View {

    var size: CGFloat = 128

    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            LottieView(name: "cat_loading", loopMode: .loop)
                .frame(width: size, height: size)
            
        }.ignoresSafeArea()
    }
}
