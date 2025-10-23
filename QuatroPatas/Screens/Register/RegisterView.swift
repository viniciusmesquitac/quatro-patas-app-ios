//
//  RegisterView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//
import SwiftUI
import FirebaseAuth

struct RegisterView: View {

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    
    @State private var isLoading = false
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @Environment(\.toast) var toast
    
    enum Field: Hashable {
        case email
        case password
        case name
    }
    
    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Vamos Lá!")
                        .font(.title)
                        .bold()
                        .padding(.top, 60)
                    
                    TextField("Apelido", text: $name)
                        .textFieldStyle(PrimaryTextFieldStyle())
                        .focused($focusedField, equals: .name)
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(PrimaryTextFieldStyle())
                        .onChange(of: email) { _, newValue in
                            email = newValue.lowercased()
                        }
                        .focused($focusedField, equals: .email)
                    
                    PasswordField(
                        title: "Senha",
                        text: $password,
                    ).frame(height: 44)
                    
                    PasswordField(
                        title: "Repetir senha",
                        text: $passwordConfirmation,
                    ).frame(height: 44)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, Padding.xLarge.rawValue)
            }
        }
        .navigationTitle("Cadastro")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button {
                    focusedField = nil
                    registerUser()
                } label: {
                    SFIcon.image(.next, scale: .large, color: .customBackground)
                }
                .disabled(isLoading)
                .padding(.horizontal, Padding.large.rawValue)
                .padding(.vertical, Padding.medium.rawValue)
                .buttonStyle(CircleButtonStyle())
                .disabled(isLoading)
            }
        }
        .overlay {
            if isLoading {
                LoadingView()
                    .ignoresSafeArea()
            }
        }
    }
    

    private func registerUser() {
        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password == passwordConfirmation else {
            toast("Preencha todos os campos e confirme a senha corretamente.", .error)
            return
        }
        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                isLoading = false
                toast(error.localizedDescription, .error)
                return
            }

            guard let firebaseUser = result?.user else { return }

            // Atualiza displayName no Auth
            let changeRequest = firebaseUser.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { _ in

                // Cria objeto AppUser com dados extras
                let appUser = User(id: firebaseUser.uid,
                                   name: name,
                                   email: email,
                                   type: .adopter)

                // Salva no Firestore na coleção "users" usando UID como ID
                Task {
                    do {
                        _ = try await databaseProvider.add(appUser,
                                                    to: "users",
                                                    withID: firebaseUser.uid)
                        navigator.popToRoot()
                        userSession.isLoggedIn = true
                    } catch {
                        toast("Erro salvando usuário: \(error.localizedDescription)", .error)
                    }
                    isLoading = false
                }
            }
        }
    }
}
