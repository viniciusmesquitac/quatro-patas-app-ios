//
//  AnnotationListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/10/25.
//

import SwiftUI

struct AnnotationListView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast

    @State var isLoading: Bool = false
    @State var annotations: [Annotation] = []

    var animalId: String

    var path: String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals/\(animalId)/annotations"
    }

    var body: some View {
        ZStack {
            List {
                ForEach(annotations, id: \.id) { annotation in
                    AnnotationRowView(annotation: annotation)
                        .onTapGesture {
                            navigator.navigate(to: .annotationDetails(annotation, animalId))
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task { await delete(annotation) }
                            } label: {
                                Label("Deletar", systemImage: SFIcon.delete.rawValue)
                            }
                        }
                }
            }
            .if(annotations.isEmpty && isLoading == false) { view in
                view.emptyState(.search, action: addAnotation)
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Anotações")
            .toolbar(.hidden, for: .tabBar)
            .toolbarItem(icon: .back, placement: .topBarLeading) {
                navigator.dismiss()
            }
            .toolbarItem(icon: .add, placement: .topBarTrailing) {
                addAnotation()
            }
            .onAppear {
                Task {
                    await fetch(from: animalId)
                }
            }
        }
        
    }
    
    func addAnotation() {
        navigator.present(sheet: .addAnnotation(animalId: animalId, onAdded: {
            Task {
                await fetch(from: animalId)
            }
        }))
    }
    
    @MainActor
    func fetch(from animalId: String) async {
        do {
            isLoading = true
            defer { isLoading = false }

            guard let path = self.path else {
                toast("Erro ao carregar as anotações", .error)
                return
            }

            let fetched: [Annotation] = try await databaseProvider.fetch(from: path)

            withAnimation(.easeInOut) {
                annotations = fetched.sorted(by: { lhs, rhs in
                    return lhs.date > rhs.date
                })
            }

        } catch {
            toast("Erro ao carregar as anotações", .error)
        }
    }


    @MainActor
    func delete(_ annotation: Annotation) async {
        guard let path = self.path, let id = annotation.id else { return }
        
        do {
            _ = try await databaseProvider.delete(from: path, id: id)
            annotations.removeAll { $0.id == annotation.id }
            toast("Anotação deletada", .success)
        } catch {
            toast("Erro ao deletar a anotação", .error)
        }
    }
}
