//
//  ForgotPasswordView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/10/25.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @EnvironmentObject var navigator: Navigator
    @Environment(\.toast) var toast

    @State private var isLoading = false
    @State private var email = ""

    enum Field: Hashable { case email }
    @FocusState private var focusedField: Field?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
                Spacer()

                Text("Esqueci a senha")
                    .padding(Padding.small.rawValue)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Informe o e-mail utilizado no cadastro para recuperar sua senha.")
                    .foregroundStyle(Color.gray.opacity(0.6))
                    .padding(Padding.small.rawValue)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(PrimaryTextFieldStyle())
                    .onChange(of: email) { _, newValue in
                        email = newValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    }
                    .focused($focusedField, equals: .email)
                    .submitLabel(.send)
                    .onSubmit { triggerReset() }
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarBackButtonHidden()
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .safeAreaInset(edge: .bottom) {
            Button {
                triggerReset()
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Redefinir Senha")
                }
            }
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .padding(.bottom, Padding.medium.rawValue)
            .disabled(isLoading || !isValidEmail(email))
            .buttonStyle(PrimaryButtonStyle())
        }
        .animation(.default, value: isLoading)
    }

    private func triggerReset() {
        focusedField = nil

        guard isValidEmail(email) else {
            toast("Digite um e-mail válido.", .warning)
            return
        }

        isLoading = true


        Auth.auth().sendPasswordReset(withEmail: email) { error in
            isLoading = false

            // Boas práticas: não revelar se o e-mail existe.
            if let error = error as NSError? {
                // Alguns códigos comuns: invalid-email, user-not-found, too-many-requests, network-error
                switch AuthErrorCode.Code(rawValue: error.code) {
                case .invalidEmail:
                    toast("E-mail inválido. Verifique e tente novamente.", .warning)
                case .tooManyRequests:
                    toast("Muitas tentativas. Tente novamente mais tarde.", .warning)
                case .networkError:
                    toast("Falha de conexão. Verifique sua internet.", .warning)
                default:
                    toast("Se o e-mail estiver cadastrado, você receberá as instruções para redefinir a senha.", .success)
                }
            } else {
                toast("Se o e-mail estiver cadastrado, você receberá as instruções para redefinir a senha.", .success)
                navigator.dismiss()
            }
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        // Regex simples e suficiente para UI
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return value.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    // MARK: - Opcional: deep link para abrir o fluxo no app
    private func makeActionCodeSettings() -> ActionCodeSettings {
        let settings = ActionCodeSettings()
        // URL da sua página de "reset concluído" (tem que ser whitelisted no console do Firebase)
        settings.url = URL(string: "https://seu-dominio.com/password-reset")
        settings.handleCodeInApp = false // true se quiser abrir no app (Dynamic Links)
        settings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        // Se usar Dynamic Links, configure domains no Firebase e mude para true acima.
        return settings
    }
}
