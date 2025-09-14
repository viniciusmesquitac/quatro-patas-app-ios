//
//  UserSession.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 11/09/25.
//


import SwiftUI
import FirebaseAuth

@MainActor
class UserSession: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoggedIn: Bool = false

    /// Checa se já existe usuário logado no Firebase
    func checkAuth() async {
        if let currentUser = Auth.auth().currentUser {
            do {
                // força revalidação no servidor
                try await currentUser.reload()

                // depois do reload o currentUser pode ter sido invalidado
                if Auth.auth().currentUser == nil {
                    // usuário não existe mais
                    self.user = nil
                    self.isLoggedIn = false
                    return
                }
                // se ainda existe, monta o seu User
                
                let user: User? = try await FirestoreProvider().fetchDocument(from: "users", id: currentUser.uid)
                self.user = user
                self.isLoggedIn = true
            } catch {
                // erro no reload (ex.: usuário removido, token inválido, etc)
                print("Erro ao recarregar usuário: \(error.localizedDescription)")
                self.user = nil
                self.isLoggedIn = false
            }
        } else {
            self.user = nil
            self.isLoggedIn = false
        }
    }

    func login(user: FirebaseAuth.User) {
        self.user = User(
            id: user.uid,
            name: user.displayName ?? "Anônimo",
            email: user.email ?? "",
            type: .adopter
        )
        self.isLoggedIn = true
    }
    
    func loginAnonymous() {
        self.user = User(
            id: "",
            name: "Anônimo",
            email: "",
            type: .anonymous
        )
        self.isLoggedIn = true
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isLoggedIn = false
        } catch {
            print("Erro ao deslogar: \(error.localizedDescription)")
        }
    }
}
