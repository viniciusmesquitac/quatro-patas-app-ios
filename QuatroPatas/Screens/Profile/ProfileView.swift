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
            UserProfileCard(name: user.name)
                .padding()
            LazyVGrid(columns: columns, spacing: Spacing.xLarge.rawValue) {
                CardView(title: "Meus Animais", route: .adoption)
                CardView(title: "Doe", route: .adoption)
                CardView(title: "Quem Somos?", route: .adoption)
                CardView(title: "Formulário de Adoção", route: .adoptionForm)
            }.padding()
        }
        .navigationTitle(AppTab.localized(.menu))
        .navigationBarTitleDisplayMode(.inline)
    }
}
