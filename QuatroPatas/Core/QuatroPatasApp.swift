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

    init() {
        FirebaseApp.configure()
    }
    
    @StateObject private var networkMonitor = NetworkMonitor.shared

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .top) {
                Group {
                    TabView(selection: $navigator.selectedTab) {
                        TabItem(label: .adopt, icon: .heart) {
                            AdoptView()
                        }
                        TabItem(label: .myAnimals, icon: .paw) {
                            userSession.isLoggedIn ?
                            AnyView(AnimalsListView()) :
                            AnyView(EmptyView().emptyState(.cat))
                        }
                        TabItem(label: .ngos, icon: .ngos) {
                            NGOsView()
                        }
                        TabItem(label: .profile, icon: .person) {
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
            .environmentObject(navigator)
            .environmentObject(requestProvider)
            .environmentObject(databaseProvider)
            .environmentObject(storageProvider)
            .environmentObject(userSession)
            .environmentObject(networkMonitor)
            .animation(.spring(response: 0.4, dampingFraction: 0.8),
                       value: networkMonitor.isConnected)
        }
    }
}
