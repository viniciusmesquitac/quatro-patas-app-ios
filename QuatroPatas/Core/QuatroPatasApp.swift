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

    private let notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        FirebaseApp.configure()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Garante que não existe blur/material aplicado
        appearance.backgroundEffect = nil
    }
    
    @StateObject private var networkMonitor = NetworkMonitor.shared

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .top) {
                Group {
                    TabView(selection: $navigator.selectedTab) {
                        TabItem(label: .adopt) {
                            AdoptView()
                        }
                        TabItem(label: .myAnimals) {
                            if userSession.isLoggedIn {
                                AnimalsListView()
                            } else {
                                EmptyView().emptyState(.cat)
                            }
                        }
                        TabItem(label: .ngos) {
                            NGOsView()
                        }
                        TabItem(label: .profile) {
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
