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
                    if let photo = userSession.user?.photo, let url = URL(string: photo) {
                        CachedAsyncImage(
                            url: url,
                        )
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.primaryColor, lineWidth: 2))
                    } else {
                        Image("default-profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 2, dash: [2]))
                            )
                    }

                    Text(userSession.user?.name ?? "Anônimo")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    
                    Text(userSession.user?.type.localized ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, Padding.xxLarge.rawValue)
                
                // MARK: - Opções
                VStack(spacing: Spacing.small.rawValue) {
                    profileButton(title: "Informações Cadastrais", icon: .person) {
                        if let user = userSession.user {
                            navigator.navigate(to: .personalInformation(user))
                        }
                    }
                    if userSession.user?.type == .ngo {
                        profileButton(title: "Informações da ONG", icon: .lock) {
                            if let user = userSession.user {
                                navigator.navigate(to: .ngoInformation(user))
                            }
                        }
                        
                        profileButton(title: "Formulários", icon: .form) {
                            if let user = userSession.user {
                                navigator.navigate(to: .formsInformation(user))
                            }
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
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
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
                SFIcon.image(icon, color: isDestructive ? .red : .primaryColor)
                
                Text(title)
                    .foregroundColor(isDestructive ? .red : .primary)
                    .font(.body)
                
                Spacer()
                
                if !isDestructive {
                    SFIcon.image(.next)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
}
