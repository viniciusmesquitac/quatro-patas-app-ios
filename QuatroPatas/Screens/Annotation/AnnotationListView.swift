//
//  AnnotationListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/10/25.
//

import SwiftUI

struct AnnotationListView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
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
                            navigator.navigate(to: .annotationDetails(annotation))
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
            .listStyle(.plain)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Anotações")
            .toolbar(.hidden, for: .tabBar)
            .toolbarItem(icon: .back, placement: .topBarLeading) {
                navigator.dismiss()
            }
            .toolbarItem(icon: .add, placement: .topBarTrailing) {
                navigator.present(sheet: .addAnnotation(animalId: animalId, onAdded: {
                    Task {
                        await fetch(from: animalId)
                    }
                }))
            }
            .task {
                await fetch(from: animalId)
            }

            if annotations.isEmpty && isLoading == false {
                buildEmptyStateView()
            }
        }
        
    }
    
    @ViewBuilder
    func buildEmptyStateView() -> some View {
        VStack(spacing: Spacing.large.rawValue) {
            LottieView(name: "empty_search", loopMode: .loop)
                .frame(width: 200, height: 200)

            Text("Nenhuma anotação cadastrada")
                .font(.system(size: 24))

            Button("Adicionar Anotação") {
                navigator.present(sheet: .addAnnotation(animalId: animalId, onAdded: {
                    Task {
                        await fetch(from: animalId)
                    }
                }))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 40)
    }
    
    @MainActor
    func fetch(from animalId: String) async {
        do {
            isLoading = true
            guard let path = self.path else {
                toast("Erro ao carregar as anotações", .error)
                return
            }
            let items: [Annotation] = try await firestoreProvider.fetch(from: path)

            let newOnes = items.filter { new in
                !annotations.contains { $0.id == new.id }
            }
            
            withAnimation {
                annotations.append(contentsOf: newOnes)
            }
            
            isLoading = false
        } catch {
            toast("Erro ao carregar as anotações", .error)
        }
    }

    @MainActor
    func delete(_ annotation: Annotation) async {
        guard let path = self.path, let id = annotation.id else { return }
        
        do {
            _ = try await firestoreProvider.delete(from: path, id: id)
            annotations.removeAll { $0.id == annotation.id }
            toast("Anotação deletada", .success)
        } catch {
            toast("Erro ao deletar a anotação", .error)
        }
    }
}
