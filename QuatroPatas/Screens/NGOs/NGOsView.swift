//
//  NGOsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct NGOsView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var databaseProvider: DatabaseProvider
    
    @Environment(\.toast) var toast

    @State var ngos: [User] = []
    @State var isLoading: Bool = false

    var body: some View {
        ScrollView {
            ForEach(ngos, id: \.self) { ngo in
                NGORowView(ngo: ngo) {
                    navigator.navigate(to: .ngoDetails(ngo))
                }
                .padding(Padding.medium.rawValue)
            }
        }
        .refreshable {
            Task {
                await fetchNGOs()
            }
        }
        .navigationTitle("Ongs")
        .task {
            if ngos.isEmpty {
                await fetchNGOs()
            }
        }
    }

    @MainActor
    func fetchNGOs() async {
        do {
            isLoading = true
            let items: [User] = try await databaseProvider.fetch(from: "users", query: { ref in
                ref.whereField("type", isEqualTo: "usertype.ngo")
            })
            self.ngos = items
            isLoading = false
        } catch {
            isLoading = false
            toast("Erro ao carregar as ONGs", .error)
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }
}
