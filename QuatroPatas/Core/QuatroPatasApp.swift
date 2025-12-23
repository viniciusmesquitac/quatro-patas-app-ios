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
    
    @StateObject private var networkMonitor = NetworkMonitor.shared

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .top) {
                Group {
                    TabView(selection: $navigator.selectedTab) {
                        TabItem(label: .animals, icon: .paw) {
                            AnimalsView()
                        }
                        TabItem(label: .adoption, icon: .heart) {
                            AdoptionView()
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
                .toast()
                if !networkMonitor.isConnected {
                    NetworkBannerView()
                        .transition(.move(edge: .top)
                            .combined(with: .opacity))
                        .zIndex(1)
                }
            }
            // environments aplicados uma única vez no container
            .environmentObject(navigator)
            .environmentObject(requestProvider)
            .environmentObject(databaseProvider)
            .environmentObject(storageProvider)
            .environmentObject(userSession)
            .environmentObject(formSession)
            .environmentObject(networkMonitor) // se quiser usar em outras views também
            .animation(.spring(response: 0.4, dampingFraction: 0.8),
                       value: networkMonitor.isConnected)
        }
    }
}
