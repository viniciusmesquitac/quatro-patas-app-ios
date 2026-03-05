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
        ProgressView()
            .tint(Color.primaryColor)
            .frame(width: size, height: size)
    }
}
