//
//  ProfileView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct MenuView: View {
    
    @State var user: User

    var body: some View {
        ScrollView {
            UserProfileCard(name: user.name).padding()
            VStack(alignment: .leading, spacing: Spacing.xLarge.rawValue) {
                HStack(spacing: Spacing.large.rawValue) {
                    CardView(title: ProfileCard.termsOfService, route: .adoption)
                    CardView(title: ProfileCard.happyEndings, route: .adoption)
                }

                HStack(spacing: Spacing.large.rawValue) {
                    CardView(title: ProfileCard.whoWeAre, route: .adoption)
                    CardView(title: ProfileCard.adoptionTerm, route: .adoptionForm)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(AppTab.localized(.menu))
        .navigationBarTitleDisplayMode(.inline)
    }
}
