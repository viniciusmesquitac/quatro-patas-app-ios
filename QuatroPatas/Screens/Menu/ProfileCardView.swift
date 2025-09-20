//
//  ProfileCardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/09/25.
//

import SwiftUI

struct ProfileCardView: View {
    
    @Binding var user: User
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        HStack(alignment: .center) {
            Image("default-profile")
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(CornerRadius.large.rawValue)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Olá, \(user.name)")
                    .font(.headline)
                if !(user.type == .anonymous) {
                    Button(action: {
                        navigator.navigate(to: .editProfile(user))
                    }) {
                        Text("Ver perfil")
                            .font(.subheadline)
                            .foregroundColor(Color.primaryColor)
                    }
                }
            }
            
            Spacer()
        }
    }
}
