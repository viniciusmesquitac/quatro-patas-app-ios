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
    @EnvironmentObject var firestore: FirestoreProvider
    @Environment(\.toast) var toast

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Vamos Lá")
                        .font(.title)
                        .bold()
                        .padding(.top, 60)
                    
                    TextField("Apelido", text: $name)
                        .textFieldStyle(PrimaryTextFieldStyle())
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(PrimaryTextFieldStyle())
                    
                    SecureField("Senha", text: $password)
                        .textFieldStyle(PrimaryTextFieldStyle())
                    
                    SecureField("Repetir senha", text: $passwordConfirmation)
                        .textFieldStyle(PrimaryTextFieldStyle())
                    
                    Spacer(minLength: 100)
                    
                    HStack {
                        Spacer()
                        Button {
                            registerUser()
                        } label: {
                            SFIcon.image(.next, scale: .large, color: .neutralWhite)
                        }
                        .buttonStyle(CircleButtonStyle())
                        .disabled(isLoading)
                    }
                }
                .padding(.horizontal, 20)
            }
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
                        _ = try await firestore.add(appUser,
                                                    to: "users",
                                                    withID: firebaseUser.uid)
                        // Atualiza sessão
                        userSession.login(user: firebaseUser)
                        navigator.dismiss()
                    } catch {
                        toast("Erro salvando usuário: \(error.localizedDescription)", .error)
                    }
                    isLoading = false
                }
            }
        }
    }
}
