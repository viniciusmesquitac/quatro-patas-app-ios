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
                navigator.popToRoot()
                Task {
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    withAnimation {
                        userSession.logout()
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
        .presentationDetents([.fraction(0.3)])
        .presentationCornerRadius(24)
        .padding()
    }
}
