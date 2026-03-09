//
//  NGOsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI
import SwiftUI

struct NGOsView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var databaseProvider: DatabaseProvider

    @Environment(\.toast) var toast

    @State private var ngos: [User] = []
    @State private var isLoading: Bool = false

    // ✅ igual ao MenuView
    @State private var animate = false
    @State private var didAnimate = false

    var body: some View {
        ScrollView {
            ForEach(ngos.indices, id: \.self) { index in
                let ngo = ngos[index]

                NGORowView(ngo: ngo) {
                    navigator.navigate(to: .ngoDetails(ngo))
                }
                .padding(Padding.small.rawValue)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 30)
                .animation(
                    .spring().delay(Double(index) * 0.08),
                    value: animate
                )
            }
        }
        .refreshable {
            await fetchNGOs()
        }
        .navigationTitle("Ongs")
        .task {
            if ngos.isEmpty {
                await fetchNGOs()
            }
        }
        .onAppear {
            guard !didAnimate else { return }

            animate = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animate = true
                didAnimate = true
            }
        }
    }

    @MainActor
    func fetchNGOs() async {
        do {
            if ngos.isEmpty {
                isLoading = true
            } else {
                isLoading = true
            }

            let items: [User] = try await databaseProvider.fetch(from: "users", query: { ref in
                ref.whereField("type", isEqualTo: "usertype.ngo")
            })

            animate = false
            ngos = items

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                animate = true
            }

            isLoading = false

        } catch {
            isLoading = false
            toast("Erro ao carregar as ONGs", .error)
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }
}
