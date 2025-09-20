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

    private var cards: [MenuCard] {
        guard let type = userSession.user?.type else { return [] }
        return MenuCardFactory().allCases(
            for: type,
            navigator: navigator,
            userSession: userSession
        )
    }
    
    var body: some View {
        ScrollView {
            if let user = userSession.user {
                Spacer()
                ProfileCardView(user: Binding(
                    get: { userSession.user ?? user },
                    set: { userSession.user = $0 }
                ))
                    .padding(.horizontal, Padding.xxLarge.rawValue)

            }
            LazyVGrid(columns: columns, spacing: Spacing.xLarge.rawValue) {
                ForEach(cards, id: \.title) { card in
                    CardView(title: card.title, icon: card.icon) {
                        card.action()
                    }
                    .transition(card.transition ?? .identity)
                }
            }
            .animation(.spring(), value: userSession.user?.type)
            .padding()
        }
        .onAppear {
            Task { await checkUser() }
        }
    }

    func checkUser() async {
        if !(userSession.user?.type == .anonymous) {
            await userSession.checkAuth()
        }
    }
}
