//
//  EditProfileView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 17/09/25.
//

import SwiftUI

struct EditProfileView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: FirestoreProvider
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast
    @State var user: User

    @State var name: String = ""
    @State var email: String = ""
    @State var instagram: String = ""
    @State var phone: String = ""
    
    @State var isLoading: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: Spacing.xLarge.rawValue) {

                TextField("Nome", text: $name)
                    .textFieldStyle(PrimaryTextFieldStyle())
                
                TextField("Email", text: $email)
                    .disabled(true)
                    .foregroundStyle(Color.gray)
                    .textFieldStyle(PrimaryTextFieldStyle())
                
                TextField("Instagram (Opcional)", text: $instagram)
                    .textFieldStyle(PrimaryTextFieldStyle())
                
                TextField("Telefone (Opcional)", text: $phone)
                    .textFieldStyle(PrimaryTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: phone) { _, newValue in
                        var digits = newValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        if digits.count > 11 {
                            digits = String(digits.prefix(11))
                        }
                        phone = PhoneFormatter.applyMask(digits)
                    }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .buttonStyle(PrimaryButtonStyle())
            .toolbarItem(icon: .back, placement: .topBarLeading) {
                navigator.dismiss()
            }
            .onAppear {
                name = user.name
                email = user.email
                instagram = user.instagram ?? ""
                phone = user.phone ?? ""
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button("Salvar") {
                Task {
                    do {
                        isLoading = true
                        var updatedUser = user
                        updatedUser.name = name
                        updatedUser.instagram = instagram
                        updatedUser.phone = phone
                        try await _ = databaseProvider.update(updatedUser, in: "users", withID: user.id)
                        await userSession.checkAuth()
                        isLoading = false
                        toast("Atualizado com sucesso!", .success)
                    } catch {
                        toast(error.localizedDescription, .error)
                    }
                }
            }
            .padding(Padding.xxLarge.rawValue)
            .buttonStyle(PrimaryButtonStyle(isLoading: isLoading))
        }

    }
}
