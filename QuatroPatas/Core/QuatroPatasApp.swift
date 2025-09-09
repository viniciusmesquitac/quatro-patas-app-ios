//
//  QuatroPatasApp.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

import SwiftUI
import FirebaseCore

@main
struct QuatroPatasApp: App {

    @StateObject private var navigator = Navigator()
    @StateObject private var requestProvider = RequestProvider()
    @StateObject private var databaseProvider = FirestoreProvider()
    @StateObject private var formManager = FormManager()

    @State private var user = User(id: String(), name: "Anônimo", email: String(), type: .adopter)
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                TabItem(label: .animals, icon: .paw) {
                    AnimalsView()
                }
                TabItem(label: .menu, icon: .menu) {
                    MenuView(user: user)
                }
            }
            .sheet(item: $navigator.presentedSheet) { sheet in
                SheetDestinationView(sheet: sheet)
            }
            //.tabBarMinimizeBehavior(.onScrollDown)
            .environmentObject(navigator)
            .environmentObject(requestProvider)
            .environmentObject(databaseProvider)
            .environmentObject(formManager)
            .tint(Color.primaryColor)
            .toast()
        }
    }
}
