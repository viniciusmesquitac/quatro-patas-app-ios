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
    
    @EnvironmentObject var userSession: UserSession
    
    @State private var nonce: String?
    @State var isLoading: Bool = false
    
    var body: some View {
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
    
    private func loginWithFirebase(authorization: ASAuthorization) {
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
            isLoading = true
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
                isLoading = false
            }
        }
    }
}
