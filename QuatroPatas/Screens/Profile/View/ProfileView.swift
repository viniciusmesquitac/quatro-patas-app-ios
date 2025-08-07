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
    
    let user: User = User(id: "0", name: "Chrystian Abarzua", email: "chrystian_abarzua124@gmail.com", type: .adopter)
    
    
    private let navigationTitle: String = "Perfil"
    
    
    var UserProfile: some View {
        HStack {
            SFIcons.image(.person)
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text("Ver Perfil")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(16)
    }
    
    
    var AdoptionForm: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Formulário de adoção")
                .font(.headline)
            Text("Nunc pretium, diam at vulputate tincidunt, augue sapien ultrices dui, et dapibus tortor nibh vel mi.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(16)
    }
    
    var HappyEnding: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Finais Felizes")
                    .font(.headline)
                Spacer()
                Text("veja mais")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                    }
                }
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                UserProfile
                HappyEnding
                AdoptionForm

                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Quem Somos")
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(16)
                    }

                    Button(action: {}) {
                        Text("Termos de Serviço")
                            .frame(maxWidth: .infinity,  minHeight: 150)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(16)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
