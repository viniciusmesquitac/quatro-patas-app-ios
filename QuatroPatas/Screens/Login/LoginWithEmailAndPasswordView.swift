//
//  LoginWithEmailAndPasswordView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//

import SwiftUI
import FirebaseAuth

struct LoginWithEmailAndPasswordView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject private var userSession: UserSession
    @Environment(\.toast) var toast
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isLoading: Bool = false

    var body: some View {
        ScrollView {
            Spacer(minLength: UIScreen.main.bounds.height / 4)
            VStack(alignment: .center, spacing: Spacing.xLarge.rawValue) {
                TextField("Email", text: $email)
                    .textFieldStyle(PrimaryTextFieldStyle())
                
                SecureField("Senha", text: $password)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(PrimaryTextFieldStyle())
                
                Spacer()
                
                Button("Entrar") {
                    login()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Button("Entrar como Anônimo") {
                    userSession.loginAnonymous()
                    navigator.dismiss()
                }
                .buttonStyle(OutlineRoundedButtonStyle())
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
        }
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    navigator.dismiss()
                } label: {
                    SFIcon.image(.back)
                }
                .buttonStyle(FloatingButtonStyle())
                Spacer()
            }.padding(.horizontal)
        }
    }
    
    
    func login() {
        guard !email.isEmpty,
              !password.isEmpty else {
            toast("Preencha seu email e senha", .error)
            return
        }
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                toast("Email ou senha incorreta", .error)
                isLoading = false
                return
            }

            guard let firebaseUser = result?.user else { return }

            userSession.login(user: firebaseUser)
            isLoading = false
            navigator.popToRoot()
        }
    }

}
