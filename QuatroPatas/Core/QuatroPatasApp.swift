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
    @StateObject private var databaseProvider = DatabaseProvider()
    @StateObject private var storageProvider = StorageProvider()
    @StateObject private var userSession = UserSession()
    @StateObject private var formSession = FormSessionManager()


    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                TabView(selection: $navigator.selectedTab) {
                    TabItem(label: .animals, icon: .paw) {
                        AnimalsView()
                    }
                    TabItem(label: .menu, icon: .menu) {
                        MenuView()
                    }
                }
                .tint(Color.primaryColor)
                .sheet(item: $navigator.presentedSheet) { sheet in
                    SheetDestinationView(sheet: sheet)
                }
            }
            .environmentObject(navigator)
            .environmentObject(requestProvider)
            .environmentObject(databaseProvider)
            .environmentObject(storageProvider)
            .environmentObject(userSession)
            .environmentObject(formSession)
            .toast()
        }
    }
    
}
