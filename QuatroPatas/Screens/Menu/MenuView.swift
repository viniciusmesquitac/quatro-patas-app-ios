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
    
    @State private var animate = false
    @State private var didAnimate = false

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
                ForEach(cards.indices, id: \.self) { index in
                    let card = cards[index]
                    
                    CardView(title: card.title, icon: card.icon) {
                        card.action()
                    }
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 30)
                    .animation(
                        .spring().delay(Double(index) * 0.1),
                        value: animate
                    )
                }
            }
            .padding()
        }
        .onAppear {
            guard !didAnimate else { return }
            
            animate = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animate = true
                didAnimate = true
            }
        }
    }
}
