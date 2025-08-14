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
    
    var UserProfile: some View {
        HStack {
            Image(systemName: SFIcons.person.rawValue)
                .resizable()
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
        .cornerRadius(16)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge.rawValue) {
                UserProfile

                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Termo de adoção")
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .padding()
                            .background(Color.secundaryColor)
                            .cornerRadius(16)
                    }

                    Button(action: {}) {
                        Text("Finais Felizes")
                            .frame(maxWidth: .infinity,  minHeight: 150)
                            .padding()
                            .background(Color.secundaryColor)
                            .cornerRadius(16)
                    }
                }

                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Quem Somos")
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .padding()
                            .background(Color.secundaryColor)
                            .cornerRadius(16)
                    }

                    Button(action: {}) {
                        Text("Termos de Serviço")
                            .frame(maxWidth: .infinity,  minHeight: 150)
                            .padding()
                            .background(Color.secundaryColor)
                            .cornerRadius(16)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(AppTab.localized(.profile))
        .navigationBarTitleDisplayMode(.inline)
    }
}
