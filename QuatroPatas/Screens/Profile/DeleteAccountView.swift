//
//  DeleteAccountView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 08/10/25.
//

import SwiftUI
import FirebaseAuth

struct DeleteAccountView: View {
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var storageProvider: StorageProvider
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast

    let onDelete: (DeleteAction) -> Void

    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            Text("Tem certeza que deseja deletar sua conta?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Essa ação é permanente e removerá todos os seus dados, incluindo animais cadastrados e fotos.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Sim, deletar conta") {
                navigator.dismiss()
                onDelete(.startLoading)
                Task {
                    await deleteAccount()
                }
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: .red))

            Button("Cancelar") {
                navigator.dismiss()
            }
            .buttonStyle(OutlineRoundedButtonStyle())
        }
        .interactiveDismissDisabled(false)
        .presentationDetents([.fraction(0.35)])
        .presentationCornerRadius(24)
        .padding()
    }

    // MARK: - Delete Account Logic
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser,
              let userId = userSession.user?.id else {
            toast("Erro ao identificar usuário.", .error)
            onDelete(.finished(false))
            return
        }

        do {
            onDelete(.startLoading)
            
            // 4️⃣ Deleta usuário do Auth (com tratamento)
            do {
                try await user.delete()
            } catch let error as NSError where error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                await MainActor.run {
                    toast("Você precisa entrar novamente para deletar sua conta.", .warning)
                }
                throw error
            }

            // 5️⃣ Atualiza sessão local e UI
            await MainActor.run {
                userSession.logout()
                onDelete(.finished(true))
                toast("Conta deletada com sucesso!", .success)
                navigator.popToRoot()
            }

            // 1️⃣ Busca os animais antes de apagar dados
            let animals: [Animal] = try await databaseProvider.fetch(from: "users/\(userId)/animals")

            // 2️⃣ Deleta dados do Firestore
            try await databaseProvider.deleteUserCollections(userId: userId)

            // 3️⃣ Deleta imagens associadas
            for item in animals {
                if let id = item.fileId {
                    try await storageProvider.deleteFolder(path: "animals/\(id)")
                }
            }
            try await storageProvider.deleteFolder(path: "users/\(userId)")

        } catch  let error as NSError {
            print("❌ Erro ao deletar conta: \(error)")
            if error.code == 17014 {
                toast("Você precisa entrar novamente para deletar sua conta.", .warning)
                return
            }
            await MainActor.run {
                toast("Não foi possível deletar a conta. Tente novamente.", .error)
                onDelete(.finished(false))
            }
        }
    }

}
