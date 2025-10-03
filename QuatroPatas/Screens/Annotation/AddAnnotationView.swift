//
//  AddAnnotationView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/10/25.
//

import SwiftUI

struct AddAnnotationView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    
    @Environment(\.toast) var toast
    
    var animalId: String
    var onAdded: (() -> Void)
    
    var path: String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals/\(animalId)/annotations"
    }
    
    @State private var date: Date = Date()
    @State private var text: String = ""
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .ignoresSafeArea(edges: .all)
        }
        .navigationTitle("Descrição")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarItem(label: "Salvar", placement: .topBarTrailing, action: {
            save()
        })
    }
    
    private func save() {
        guard let path = path else {
            toast("Erro ao salvar: caminho inválido", .error)
            return
        }
        
        isLoading = true
        
        let dateString = ISO8601DateFormatter().string(from: date)
        let annotation = Annotation(text: text, date: dateString)
        
        Task {
            do {
                _ = try await firestoreProvider.add(annotation, to: path)
                isLoading = false
                toast("Anotação adicionada com sucesso!", .success)
                onAdded()
                navigator.dismiss()
            } catch {
                isLoading = false
                toast(error.localizedDescription, .error)
            }
        }
    }
    
    
    
    
}
