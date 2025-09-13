//
//  LogoutView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 11/09/25.
//

import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            Text("Você tem certeza que quer sair?")
                .font(.headline)
            
            Button("Sair") {
                navigator.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        userSession.isLoggedIn = false
                    }
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button("Cancelar") {
                navigator.dismiss()
            }
            .buttonStyle(OutlineRoundedButtonStyle())

        }
        .interactiveDismissDisabled(false)
        .presentationDetents([.fraction(0.3)]) // 30% da tela
        .presentationCornerRadius(24)          // bordas arredondadas
//        .presentationBackgroundInteraction(.enabled)
        .padding()
    }
}
