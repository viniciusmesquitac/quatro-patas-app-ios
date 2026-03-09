//
//  EditPersonalInformationView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 17/09/25.
//

import SwiftUI

struct EditPersonalInformationView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast
    @State var user: User

    @State var name: String = ""
    @State var cnpj: String = ""
    @State var email: String = ""
    @State var instagram: String = ""
    @State var phone: String = ""
    
    @State var isLoading: Bool = false

    private var hasChanges: Bool {
        name != user.name ||
        instagram != (user.instagram ?? "") ||
        phone != (user.phone ?? "")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: Spacing.xLarge.rawValue) {
    
                FloatingBorderLabelTextField(placeholder: "Nome", text: $name)
                
                FloatingBorderLabelTextField(placeholder: "CNPJ", disabled: true, text: $cnpj)

                FloatingBorderLabelTextField(placeholder: "Email", disabled: true, text: $email)
                
                FloatingBorderLabelTextField(placeholder: "Instagram", text: $instagram)
                
                FloatingBorderLabelTextField(placeholder: "Telefone", text: $phone)
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
            .toolbarMenu(icon: .more, actions: [
                .init(label: "Deletar minha conta", icon: .delete, action: {
                    navigator.present(sheet: .deleteAccount(onDelete: { delete in
                        switch delete {
                        case .startLoading:
                            isLoading = true
                        case .finished(_):
                            isLoading = false
                        }
                    }))
                })
            ])
            .onAppear {
                name = user.name
                email = user.email
                cnpj = user.cnpj ?? ""
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
                        isLoading = false
                        toast("Atualizado com sucesso!", .success)
                    } catch {
                        toast(error.localizedDescription, .error)
                    }
                }
            }
            .disabled(!hasChanges)
            .padding(Padding.xxLarge.rawValue)
            .buttonStyle(PrimaryButtonStyle(isLoading: isLoading, isEnabled: hasChanges))
        }

    }
}
