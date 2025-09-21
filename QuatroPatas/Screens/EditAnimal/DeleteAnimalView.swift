//
//  DeleteAnimalView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

struct DeleteAnimalView: View {
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider

    @State var animal: Animal
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            Text("Você tem certeza que quer deletar esse animal? OBS: Está opereção não pode ser desfeita.")
                .font(.headline)
            
            Button("Sim") {
                navigator.dismiss()
                Task {
                    let userType = userSession.user?.type ?? .anonymous
                    let userId = userSession.user?.id ?? ""
                    let animalId = animal.id ?? ""
                    
                    var path = ""
                    switch userType {
                    case .volunteer, .ngo:
                        path = "animals"
                    case .adopter:
                        path = "users/\(userId)/animals"
                    case .anonymous:
                        path = ""
                    }
                    do {
                        let result = try await firestoreProvider.delete(from: path, id: animalId)
                        navigator.dismiss()
                        if result {
                            toast("Animal deletado com sucesso!", .success)
                        }
                    } catch {
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
