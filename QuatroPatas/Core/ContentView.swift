//
//  ContentView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            NavigationStack {
                AnimalsView()
            }.tabItem {
                Label("Animais", systemImage: "pawprint")
            }
            NavigationStack {
                AdoptionView()
            }.tabItem {
                Label("Adoção", systemImage: "pawprint")
            }
            NavigationStack {
                ProfileView()
            }.tabItem {
                Label("Perfil", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
