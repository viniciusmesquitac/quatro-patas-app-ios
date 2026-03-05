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
    
    enum Field: Hashable {
        case email
        case password
    }
    @FocusState private var focusedField: Field?

    @State var isLoading: Bool = false
    
    var isEnabled: Bool {
        !isLoading && !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        ScrollView {
            Image("icon")
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
                    .focused($focusedField, equals: .email)
                
                SecureField("Senha", text: $password)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(PrimaryTextFieldStyle())
                    .focused($focusedField, equals: .password)
                
                HStack {
                    Spacer()
                    Button("Esqueci a senha") {
                        navigator.navigate(to: .forgotPassword)
                    }.foregroundStyle(Color.primaryColor)
                }
                
                Spacer()
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
        }
        .navigationBarBackButtonHidden()
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .safeAreaInset(edge: .bottom) {
            Button("Entrar") {
                focusedField = nil
                login()
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .padding(.bottom, Padding.medium.rawValue)
            .buttonStyle(PrimaryButtonStyle(isLoading: isLoading, isEnabled: isEnabled))
        }
    }
    
    
    func login() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                toast("Email ou senha incorreta", .error)
                isLoading = false
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoading = false
                navigator.popToRoot()
            }
        }
    }

}
