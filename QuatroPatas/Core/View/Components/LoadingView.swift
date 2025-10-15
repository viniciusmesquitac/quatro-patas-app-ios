//
//  LoadingView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//

import SwiftUI

struct LoadingView: View {

    var size: CGFloat = 64

    var body: some View {
        ZStack {
            Rectangle().fill(Color.customBackground)
            ProgressView()
                .frame(width: size, height: size)
                .background(.background, in: .rect(cornerRadius: CornerRadius.medium.rawValue))
            
        }.ignoresSafeArea()
    }
}
