//
//  QuatroPatasApp.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

import SwiftUI

enum AppTab: String, Localizable {
    case animals
    case adoption
    case profile
    case search
}

@main
struct QuatroPatasApp: App {

    @StateObject private var navigator = Navigator()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack(path: $navigator.path) {
                    AnimalsView().applyRoute()
                }.tabItem {
                    Label("Animais", systemImage: SFIcons.paw.rawValue)
                }
                NavigationStack(path: $navigator.path) {
                    AdoptionView().applyRoute()
                }.tabItem {
                    Label("Adoção", systemImage: SFIcons.heart_filled.rawValue)
                }
                NavigationStack(path: $navigator.path) {
                    ProfileView().applyRoute()
                }.tabItem {
                    Label("Perfil", systemImage:  SFIcons.person.rawValue)
                }
            }
            .sheet(item: $navigator.presentedSheet) { sheet in
                SheetDestinationView(sheet: sheet)
            }
            .environmentObject(navigator)
            .tint(Color.primaryColor)
        }
    }
}
