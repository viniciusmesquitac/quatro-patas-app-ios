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

    @State var isLoading: Bool = false
    @State var vaccines: [Vaccine] = [
        Vaccine(name: "teste", date: "teste")
    ]

    var animalId: String
    var userId: String

    var vaccinePath: String {
        return "users/\(userId)/animals/\(animalId)/vaccines"
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Padding.medium.rawValue) {
                ForEach(vaccines, id: \.id) { vacine in
                    VaccineRowView(vaccine: vacine)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Vacinas")
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbarItem(icon: .add, placement: .topBarTrailing) {
            navigator.navigate(to: .addvaccine("", ""))
        }
        .task {
            
        }
        
    }
    
    @MainActor
    func fetchVaccine(from animalId: String) async {
        do {
            isLoading = true
            let items: [Vaccine] = try await firestoreProvider.fetch(from: vaccinePath)
            self.vaccines = items
            isLoading = false
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }
}
