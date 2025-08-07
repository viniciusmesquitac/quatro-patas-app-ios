//
//  ContentView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var navigator = Navigator()

    var body: some View {
        TabView {
            NavigationStack(path: $navigator.path) {
                AnimalsView().applyRoute()
            }.tabItem {
                Label("Animais", systemImage: SFIcons.paw.rawValue)
            }
            NavigationStack(path: $navigator.path) {
                AdoptionView().applyRoute()
            }.tabItem {
                Label("Adoção", systemImage: SFIcons.paw.rawValue)
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
        .tint(.red)
    }
}

#Preview {
    ContentView()
}
