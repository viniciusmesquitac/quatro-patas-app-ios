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
            AnimalsView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Animais")
                }

            AdoptionView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Adoção")
                }
    
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Perfil")
                }
        }
    }
}

#Preview {
    ContentView()
}
