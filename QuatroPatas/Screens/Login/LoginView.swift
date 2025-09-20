//
//  LoginView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 10/09/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject private var userSession: UserSession
    @Environment(\.toast) var toast
    
    @State private var nonce: String?
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.primaryColor)
                .frame(height: UIScreen.main.bounds.height / 2)
                .ignoresSafeArea(edges: .top)
            Spacer()
        }
        
        VStack(spacing: Spacing.large.rawValue) {
            
            Button("Criar uma conta") {
                navigator.navigate(to: .register)
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .buttonStyle(PrimaryButtonStyle())

            Button("Entrar") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut) {
                        navigator.navigate(to: .loginWithEmailAndPassword)
                    }
                }
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .buttonStyle(OutlineRoundedButtonStyle())
            
            Text("Ao continuar, você concorda com nossos termos de uso e política de privacidade.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, Padding.xxLarge.rawValue)
                .padding(.top, Padding.medium.rawValue)
            Spacer()
        }
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
    }
    
}
