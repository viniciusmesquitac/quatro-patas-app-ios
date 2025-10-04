//
//  MedicationListView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/10/25.
//

import SwiftUI

struct MedicationListView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    @EnvironmentObject var userSession: UserSession
    
    @Environment(\.toast) var toast

    @State var isLoading: Bool = false
    @State var medications: [Medication] = []

    var animalId: String

    var vaccinePath: String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals/\(animalId)/medications"
    }

    var body: some View {
        ZStack {
            List {
                ForEach(medications, id: \.id) { medication in
                    MedicationRowView(medication: medication)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task { await delete(medication) }
                            } label: {
                                Label("Deletar", systemImage: SFIcon.delete.rawValue)
                            }
                        }
                }
            }
            .if(medications.isEmpty && isLoading == false) { view in
                view.emptyState(
                    message: "Nenhuma Medicação cadastrada",
                    title: "Adicionar Medicação",
                    action: addMedication
                )
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Medicações")
            .toolbar(.hidden, for: .tabBar)
            .toolbarItem(icon: .back, placement: .topBarLeading) {
                navigator.dismiss()
            }
            .toolbarItem(icon: .add, placement: .topBarTrailing) {
                addMedication()
            }
            .task {
                await fetchMedication(from: animalId)
            }
        }
        
    }
    
    func addMedication() {
        navigator.present(sheet: .addMedication(animalId: animalId, onAdded: {
            Task {
                await fetchMedication(from: animalId)
            }
        }))
    }
    
    @MainActor
    func fetchMedication(from animalId: String) async {
        do {
            isLoading = true
            guard let path = vaccinePath else {
                toast("Erro ao carregar as medicações", .error)
                return
            }
            let items: [Medication] = try await firestoreProvider.fetch(from: path)

            let newOnes = items.filter { new in
                !medications.contains { $0.id == new.id }
            }
            
            withAnimation {
                medications.append(contentsOf: newOnes)
            }
            
            isLoading = false
        } catch {
            toast("Erro ao carregar as medicações", .error)
        }
    }

    @MainActor
    func delete(_ medication: Medication) async {
        guard let path = vaccinePath, let id = medication.id else { return }
        
        do {
            _ = try await firestoreProvider.delete(from: path, id: id)
            medications.removeAll { $0.id == medication.id }
            toast("Medicação deletada", .success)
        } catch {
            toast("Erro ao deletar a medicação", .error)
        }
    }
}
