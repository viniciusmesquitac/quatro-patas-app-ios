//
//  ProfileView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct MenuView: View {
    
    @State var user: User
    
    let columns = [
        GridItem(.flexible(), spacing: Spacing.large.rawValue),
        GridItem(.flexible(), spacing: Spacing.large.rawValue)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Spacing.xLarge.rawValue) {
                CardView(title: "Meus Animais", route: .animalsList)
                //CardView(title: "Doe", route: .donate)
                CardView(title: "Formulário de Adoção", route: .adoptionForm)
                if let url = URL(string: "https://4patasfortaleza.org") {
                    CardView(title: "Sobre o abrigo", route: .webView(url))
                }
            }.padding()
        }
        .navigationTitle(AppTab.localized(.menu))
        .navigationBarTitleDisplayMode(.inline)
    }
}
