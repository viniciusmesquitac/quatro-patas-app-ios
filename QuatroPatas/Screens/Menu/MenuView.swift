//
//  MenuView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct MenuView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession

    let columns = [
        GridItem(.flexible(), spacing: Spacing.large.rawValue),
        GridItem(.flexible(), spacing: Spacing.large.rawValue)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Spacing.xLarge.rawValue) {
                CardView(title: "Formulário de Adoção") {
                    navigator.navigate(to: .adoptionForm)
                }
                if let url = URL(string: "https://4patasfortaleza.org") {
                    CardView(title: "Sobre o abrigo") {
                        navigator.navigate(to: .webView(url))
                    }
                }
                CardView(title: "Sair") {
                    navigator.present(sheet: .logout)
                }
                
                if userSession.user?.type == .admin {
                    CardView(title: "Adicionar Animal") {
                            navigator.navigate(to: .addAnimal)
                        }
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(), value: userSession.user?.type)
            .padding()
        }
        .onAppear {
            Task {
                await userSession.checkAuth()
            }
        }
        .navigationTitle(AppTab.localized(.menu))
        .navigationBarTitleDisplayMode(.inline)
    }
}
