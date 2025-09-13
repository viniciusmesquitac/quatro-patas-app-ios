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
    @StateObject private var storageProvider = FirebaseStorageProvider()
    @StateObject private var formManager = FormManager()
    @StateObject private var userSession = UserSession()

    @State private var isLoggedIn: Bool = false
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if userSession.isLoggedIn {
                    TabView {
                        TabItem(label: .animals, icon: .paw) {
                            AnimalsView()
                        }
                        TabItem(label: .menu, icon: .menu) {
                            MenuView()
                        }
                    }
                    .sheet(item: $navigator.presentedSheet) { sheet in
                        SheetDestinationView(sheet: sheet)
                    }
                    .id("loggedIn")
                    .transition(.move(edge: .trailing))
                } else {
                    LoginView()
                        .id("login")
                        .transition(.move(edge: .leading))
                }
            }
            .animation(.easeInOut(duration: 0.5), value: userSession.isLoggedIn)
            .environmentObject(navigator)
            .environmentObject(requestProvider)
            .environmentObject(databaseProvider)
            .environmentObject(storageProvider)
            .environmentObject(formManager)
            .environmentObject(userSession)
            .tint(Color.primaryColor)
            .toast()
        }
    }

}
