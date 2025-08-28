//
//  QuatroPatasApp.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

import SwiftUI

@main
struct QuatroPatasApp: App {

    @StateObject private var navigator = Navigator()
    @StateObject private var requestProvider = RequestProvider()
    @StateObject private var formObservable = FormObservable()

    @State private var user = User(id: String(), name: "Anônimo", email: String(), type: .adopter)

    var body: some Scene {
        WindowGroup {
            TabView {
                TabItem(label: .animals, icon: .paw) {
                    AnimalsView()
                }
                TabItem(label: .adoption, icon: .heart_filled) {
                    AdoptionView()
                }
                TabItem(label: .profile, icon: .person) {
                    ProfileView(user: user)
                }
            }
            .sheet(item: $navigator.presentedSheet) { sheet in
                SheetDestinationView(sheet: sheet)
            }
            .tabBarMinimizeBehavior(.onScrollDown)
            .environmentObject(navigator)
            .environmentObject(requestProvider)
            .environmentObject(formObservable)
            .tint(Color.primaryColor)
        }
    }
}
