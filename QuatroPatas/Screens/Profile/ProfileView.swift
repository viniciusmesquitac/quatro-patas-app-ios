//
//  ProfileView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

//
//  ContentView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

import SwiftUI

struct ProfileView: View {
    
    @State var user: User
    
    enum Constants: String, Localizable {
        case adoptionTerm
        case happyEndings
        case whoWeAre
        case termsOfService
    }
    
    var UserProfileCard: some View {
        HStack {
            Image(systemName: SFIcons.person.rawValue)
                .resizable()
                .foregroundStyle(Color.primaryColor)
                .frame(width: 64, height: 64)

            VStack(alignment: .leading) {
                Text("Humano")
                    .font(.headline)
                    .foregroundColor(.primaryColor)
                Text("Ver Perfil")
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
                    card(title: Constants.localized(.termsOfService))
                    card(title: Constants.localized(.happyEndings))
                }

                HStack(spacing: Spacing.large.rawValue) {
                    card(title: Constants.localized(.whoWeAre))
                    card(title: Constants.localized(.adoptionTerm))
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(AppTab.localized(.profile))
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func card(title: String) -> some View {
        Button(action: {}) {
            Text(title)
                .foregroundStyle(Color.secundaryColor)
                .frame(maxWidth: .infinity, minHeight: 150)
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(CornerRadius.medium.rawValue)
        }
    }
}
