//
//  View+EmptyState.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 04/10/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func emptyState(
        name: String = "empty_search",
        message: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        ScrollView {
            VStack(spacing: Spacing.large.rawValue) {
                LottieView(name: name, loopMode: .loop)
                    .frame(width: 200, height: 200)
                
                Text(message)
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button(title, action: action)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 40)
            .transition(.opacity)
        }
    }
}
