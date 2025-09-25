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
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
            
            Spacer(minLength: 100)
    
            VStack(alignment: .center, spacing: Spacing.xLarge.rawValue) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(PrimaryTextFieldStyle())
                    .onChange(of: email) { _, newValue in
                        email = newValue.lowercased()
                    }
                
                SecureField("Senha", text: $password)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(PrimaryTextFieldStyle())
                
                Spacer()
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
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
        .safeAreaInset(edge: .bottom) {
            Button("Entrar") {
                login()
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .padding(.bottom, Padding.medium.rawValue)
            .disabled(isLoading)
            .buttonStyle(PrimaryButtonStyle())
        }
        .overlay {
            if isLoading {
                LoadingView()
                    .ignoresSafeArea()
            }
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
            isLoading = false
            navigator.popToRoot()
        }
    }

}
