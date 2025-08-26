//
//  ProfileView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct ProfileView: View {
    
    @State var user: User

    var UserProfileCard: some View {
        HStack {
            Image(systemName: SFIcon.person.rawValue)
                .resizable()
                .foregroundStyle(Color.primaryColor)
                .frame(width: 64, height: 64)

            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                    .foregroundColor(.primaryColor)
                Text("ver perfil")
                    .font(.subheadline)
                    .foregroundColor(.primaryColor)
            }
            Spacer()
        }
        .padding()
        .background(Color.secundaryColor)
        .cornerRadius(CornerRadius.medium.rawValue)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge.rawValue) {
                UserProfileCard
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
        .navigationTitle(AppTab.localized(.profile))
        .navigationBarTitleDisplayMode(.inline)
    }
}
