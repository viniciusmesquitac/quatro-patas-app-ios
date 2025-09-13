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

    init() {
        checkAuth()
    }

    /// Checa se já existe usuário logado no Firebase
    func checkAuth() {
        if let currentUser = Auth.auth().currentUser {
            self.user = User(
                id: currentUser.uid,
                name: currentUser.displayName ?? "Usuário",
                email: currentUser.email ?? "",
                type: .adopter // ou buscar do Firestore
            )
            self.isLoggedIn = true
        } else {
            self.user = nil
            self.isLoggedIn = false
        }
    }

    /// Atualiza sessão quando login for feito
    func login(user: FirebaseAuth.User) {
        self.user = User(
            id: user.uid,
            name: user.displayName ?? "Usuário",
            email: user.email ?? "",
            type: .adopter
        )
        self.isLoggedIn = true
    }

    /// Faz logout
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
