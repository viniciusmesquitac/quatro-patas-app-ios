//
//  EditNGOInformationView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//


import SwiftUI

struct EditNGOInformationView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast
    @State var user: User

    @State var location: String = ""
    @State var description: String = ""
    @State var pixKey: String = ""

    @State var isLoading: Bool = false

    private var hasChanges: Bool {
        location != user.location ||
        description != (user.description ?? "") ||
        pixKey != (user.pixKey ?? "")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: Spacing.xLarge.rawValue) {

                FloatingBorderLabelTextField(placeholder: "Chave Pix", text: $pixKey)
    
                VStack(alignment: .leading, spacing: 16) {
                    Text("Localização:")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Button(location.isEmpty ? "Selecionar cidade/UF" : location) {
                        navigator.present(sheet: .selectCityState(location: $location))
                    }.buttonStyle(OutlineRoundedButtonStyle())
                }
                
                VStack(alignment: .leading) {
                    Text("Sobre:")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    TextEditorButton(text: $description) {
                        navigator.present(sheet: .descriptionEditor($description))
                    }
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
                description = user.description ?? ""
                location = user.location ?? ""
                pixKey = user.pixKey ?? ""
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button("Salvar") {
                Task {
                    do {
                        isLoading = true
                        var updatedUser = user
                        updatedUser.location = location
                        updatedUser.description = description
                        updatedUser.pixKey = pixKey
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
