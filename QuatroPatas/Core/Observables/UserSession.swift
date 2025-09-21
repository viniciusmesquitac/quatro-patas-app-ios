//
//  UserSession.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 11/09/25.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserSession: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoggedIn: Bool = false
    
    private var authListener: AuthStateDidChangeListenerHandle?
    private var userListener: ListenerRegistration?

    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self else { return }
            
            if let firebaseUser = firebaseUser {
                Task {
                    await self.loadUserData(for: firebaseUser)
                }
            } else {
                // usuário saiu
                self.user = nil
                self.isLoggedIn = false
                // cancela listener do Firestore se existir
                self.userListener?.remove()
                self.userListener = nil
            }
        }
    }

    @MainActor
     private func loadUserData(for firebaseUser: FirebaseAuth.User) async {
         // primeiro carrega uma vez
         do {
             let fetchedUser: User? = try await FirestoreProvider()
                 .fetchDocument(from: "users", id: firebaseUser.uid)
             self.user = fetchedUser
             self.isLoggedIn = true
         } catch {
             print("Erro ao buscar usuário: \(error)")
         }
         
         // depois escuta mudanças em tempo real no documento do usuário
         listenToUserDocument(uid: firebaseUser.uid)
     }

    private func listenToUserDocument(uid: String) {
        // remove listener antigo se houver
        userListener?.remove()
        userListener = Firestore.firestore()
            .collection("users")
            .document(uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Erro no listener do usuário: \(error)")
                    return
                }
                do {
                    if let snapshot = snapshot, snapshot.exists {
                        self.user = try snapshot.data(as: User.self)
                    } else {
                        self.user = nil
                        self.isLoggedIn = false
                    }
                } catch {
                    print("Erro ao decodificar User: \(error)")
                }
            }
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
        } catch {
            print("Erro ao deslogar: \(error.localizedDescription)")
        }
    }
}
