//
//  AlertView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/09/25.
//

import SwiftUI

struct AlertView: View {
    
    var title: String
    var action: () -> Void
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            Text(title)
                .font(.headline)

            Button("Sim") {
                action()
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button("Cancelar") {
                navigator.dismiss()
            }
            .buttonStyle(OutlineRoundedButtonStyle())

        }
        .interactiveDismissDisabled(false)
        .presentationDetents([.fraction(0.3)])
        .presentationCornerRadius(24)
        .padding()
    }
}
