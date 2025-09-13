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
        NavigationStack {
            ZStack {
                VStack {
                    Rectangle()
                        .fill(Color.primaryColor)
                        .frame(height: UIScreen.main.bounds.height / 3)
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                
                VStack(spacing: Spacing.large.rawValue) {
                    Spacer(minLength: UIScreen.main.bounds.height / 6)
                    LoginCardView {
                        Text("Encontre seu\nnovo melhor amigo 🐾")
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .padding(.horizontal, Padding.large.rawValue)
                        
                        SignInWithAppleButton(.signIn) { request in
                            let nonce = randomNonceString()
                            self.nonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = sha256(nonce)
                        } onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                loginWithFirebase(authorization: authorization)
                            case .failure(let error):
                                toast(error.localizedDescription, .error)
                            }
                        }
                        .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
                        .frame(height: 50)
                        .cornerRadius(CornerRadius.large.rawValue)
                        .padding(.horizontal, Padding.xxLarge.rawValue)
                        
                        Button("Criar uma conta") {
                            // ação para criar conta / cadastro
                        }
                        .padding(.horizontal, Padding.xxLarge.rawValue)
                        .buttonStyle(PrimaryButtonStyle())
                        
                        // Entrar
                        Button("Entrar") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeInOut) {
                                    userSession.isLoggedIn = true
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
                    }
                    Spacer()
                    Spacer()
                }
                .toolbarItem(icon: .close, placement: .topBarTrailing) {
                    navigator.dismiss()
                }
            }
            .overlay {
                if isLoading {
                    LoadingView()
                }
            }
        }
    }
    
    
    @ViewBuilder
    func LoginCardView<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: Spacing.large.rawValue) {
            content()
        }
        .padding(.vertical, Padding.medium.rawValue)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                .fill(Color.customBackground)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal, Padding.medium.rawValue)
    }
    
    
    @ViewBuilder
    func LoadingView() -> some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            ProgressView().frame(width: 45, height: 45)
                .background(.background, in: .rect(cornerRadius: 5))
            
        }
    }
    
    func loginWithFirebase(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce else {
                toast("Invalid state: A login callback was received, but no login request was sent.", .error)
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                toast("Unable to fetch identity token", .error)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                toast("Unable to serialize token string from data: \(appleIDToken.debugDescription)", .error)
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    toast(error.localizedDescription, .error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                userSession.isLoggedIn = true
                isLoading = false
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

}
