//
//  SignInWithAppleView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

struct SignInWithAppleView: View {
    
    @Environment(\.colorScheme) var scheme
    @Environment(\.toast) var toast
    
    @State private var nonce: String?
    
    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            let nonce = randomNonceString()
            self.nonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                handleAuthorization(authorization)
            case .failure(let error):
                toast(error.localizedDescription, .error)
            }
        }
        .signInWithAppleButtonStyle(scheme == .dark ? .white : .black)
        .frame(height: 48)
        .cornerRadius(CornerRadius.large.rawValue)
        .padding(.horizontal, Padding.xxLarge.rawValue)
    }
}

// MARK: - Helpers
extension SignInWithAppleView {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func handleAuthorization(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            toast("Credencial inválida", .error)
            return
        }
        guard let nonce = nonce else {
            toast("Nonce inválido", .error)
            return
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            toast("Não foi possível obter o token do Apple ID", .error)
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            toast("Não foi possível converter o token em string", .error)
            return
        }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: credential) { _, error in
            if let error = error {
                toast(error.localizedDescription, .error)
            }
        }
    }
}
