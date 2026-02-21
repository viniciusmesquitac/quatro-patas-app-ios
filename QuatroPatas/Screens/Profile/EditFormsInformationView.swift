//
//  EditFormsInformationView 2.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//


import SwiftUI

struct EditFormsInformationView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast
    @State var user: User

    @State var formCat: String = ""
    @State var formDog: String = ""
    
    @State var isLoading: Bool = false

    private var hasChanges: Bool {
        formCat != (user.formCat ?? "") ||
        formDog != (user.formDog ?? "")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: Spacing.xLarge.rawValue) {
                FloatingBorderLabelTextField(placeholder: "Gatos", text: $formCat)
                
                FloatingBorderLabelTextField(placeholder: "Cachorros", text: $formDog)
            }
            .navigationTitle("Formulários")
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .padding(.horizontal, Padding.xxLarge.rawValue)
            .buttonStyle(PrimaryButtonStyle())
            .toolbarItem(icon: .back, placement: .topBarLeading) {
                navigator.dismiss()
            }
            .onAppear {
                formCat = user.formCat ?? ""
                formDog = user.formDog ?? ""
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button("Salvar") {
                Task {
                    do {
                        isLoading = true
                        var updatedUser = user
                        updatedUser.formCat = formCat
                        updatedUser.formDog = formDog
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
