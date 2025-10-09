//
//  DeleteAnimalView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

enum DeleteAction {
    case startLoading
    case finished(Bool)
}

struct DeleteAnimalView: View {
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    @EnvironmentObject var firebaseStorageProvider: FirebaseStorageProvider

    @State var animal: Animal
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast
    
    let onDelete: (DeleteAction) -> Void
    
    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            Text("Você tem certeza que quer deletar esse animal?")
                .font(.headline)
            
            Button("Sim") {
                navigator.dismiss()
                onDelete(.startLoading)
                Task {
                    guard let userId = userSession.user?.id, let fileId = animal.fileId else {
                        toast("Não foi possivel deletar esse animal, tente novamente.", .error)
                        return
                    }
                    do {
                        try await firestoreProvider.deleteAnimals(of: userId)
                        try await firebaseStorageProvider.deleteFolder(path: "animals/\(fileId)")
                        onDelete(.finished(true))
                        toast("Animal deletado com sucesso!", .success)
                        navigator.dismiss()
                        navigator.dismiss()
                    } catch {
                        onDelete(.finished(false))
                        toast("Não foi possivel deletar esse animal, tente novamente.", .error)
                    }
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button("Cancelar") {
                navigator.dismiss()
            }
            .buttonStyle(OutlineRoundedButtonStyle())

        }
        .interactiveDismissDisabled(false)
        .presentationDetents([.fraction(0.3)])
        .presentationCornerRadius(24)
        .padding()
    }
}
