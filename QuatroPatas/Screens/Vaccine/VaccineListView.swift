//
//  VaccineListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//
import SwiftUI

struct VaccineListView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    @EnvironmentObject var userSession: UserSession
    
    @Environment(\.toast) var toast

    @State var isLoading: Bool = false
    @State var vaccines: [Vaccine] = []

    var animalId: String

    var vaccinePath: String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals/\(animalId)/vaccines"
    }

    var body: some View {
        ZStack {
            List {
                ForEach(vaccines, id: \.id) { vaccine in
                    VaccineRowView(vaccine: vaccine)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task { await deleteVaccine(vaccine) }
                            } label: {
                                Label("Deletar", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Vacinas")
            .toolbar(.hidden, for: .tabBar)
            .toolbarItem(icon: .back, placement: .topBarLeading) {
                navigator.dismiss()
            }
            .toolbarItem(icon: .add, placement: .topBarTrailing) {
                navigator.present(sheet: .addVaccine(animalId: animalId, onAdded: {
                    Task {
                        await fetchVaccine(from: animalId)
                    }
                }))
            }
            .task {
                await fetchVaccine(from: animalId)
            }

            if vaccines.isEmpty && isLoading == false {
                buildEmptyStateView()
            }
        }
        
    }
    
    @ViewBuilder
    func buildEmptyStateView() -> some View {
        VStack(spacing: Spacing.large.rawValue) {
            LottieView(name: "vaccine", loopMode: .loop)
                .frame(width: 200, height: 200)

            Text("Nenhuma vacina cadastrada")
                .font(.system(size: 24))

            Button("Adicionar vacina") {
                navigator.present(sheet: .addVaccine(animalId: animalId, onAdded: {
                    Task {
                        await fetchVaccine(from: animalId)
                    }
                }))
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 40)
    }
    
    @MainActor
    func fetchVaccine(from animalId: String) async {
        do {
            isLoading = true
            guard let path = vaccinePath else {
                toast("Erro ao carregar as vacinas", .error)
                return
            }
            let items: [Vaccine] = try await firestoreProvider.fetch(from: path)

            let newOnes = items.filter { new in
                !vaccines.contains { $0.id == new.id }
            }
            
            withAnimation {
                vaccines.append(contentsOf: newOnes)
            }
            
            isLoading = false
        } catch {
            toast("Erro ao carregar as vacinas", .error)
        }
    }

    @MainActor
    func deleteVaccine(_ vaccine: Vaccine) async {
        guard let path = vaccinePath, let id = vaccine.id else { return }
        
        do {
            _ = try await firestoreProvider.delete(from: path, id: id)
            vaccines.removeAll { $0.id == vaccine.id }
            toast("Vacina deletada", .success)
        } catch {
            toast("Erro ao deletar vacina", .error)
        }
    }
}
