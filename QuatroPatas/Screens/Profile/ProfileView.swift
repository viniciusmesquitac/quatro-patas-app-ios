//
//  ProfileView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xLarge.rawValue) {
        
                VStack {
                    Image("default-profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    Text(userSession.user?.name ?? "Anônimo")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    
                    Text(userSession.user?.type.rawValue ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, Padding.xxLarge.rawValue)
                
                // MARK: - Opções
                VStack(spacing: Spacing.small.rawValue) {
                    profileButton(title: "Informações Pessoais", icon: .person) {
                        if let user = userSession.user {
                            navigator.navigate(to: .personalInformation(user))
                        }
                    }
                    profileButton(title: "Sair", icon: .signOut, isDestructive: true) {
                        navigator.present(sheet: .logout)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(CornerRadius.medium.rawValue)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                Spacer()
            }
            .padding(.horizontal, Padding.medium.rawValue)
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .navigationTitle("Perfil")
    }
    
    // MARK: - Reusable Button
    @ViewBuilder
    private func profileButton(
        title: String,
        icon: SFIcon,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon.rawValue)
                    .foregroundColor(isDestructive ? .red : .primary)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundColor(isDestructive ? .red : .primary)
                    .font(.body)
                
                Spacer()
                
                if !isDestructive {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
}
