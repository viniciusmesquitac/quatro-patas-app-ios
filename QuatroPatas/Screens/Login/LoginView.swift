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
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        ScrollView {
            animation
            content
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
    }
    
    var animation: some View {
        Rectangle()
            .fill(Color.primaryColor)
            .frame(height: UIScreen.main.bounds.height / 2.5)
            .overlay {
                LottieView(name: "like_cat", loopMode: .loop)
                    .padding(.top, 80)
            }
            .stretchy()
    }
    
    var content: some View {
        VStack(spacing: Spacing.large.rawValue) {
            Text("Encontre o seu melhor amigo aqui!")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, Padding.xxLarge.rawValue)
                .padding(.top, Padding.medium.rawValue)
            
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
    }
}

