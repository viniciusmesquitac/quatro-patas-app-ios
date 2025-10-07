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
            if let photo = user.photo, let url = URL(string: photo) {
                CachedAsyncImage(
                    url: url,
                    placeholder: "default-profile"
                )
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.primaryColor, lineWidth: 2))
            } else {
                Image("default-profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.primaryColor, style: StrokeStyle(lineWidth: 2, dash: [2]))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Olá, \(user.name)")
                    .font(.headline)
                if !(user.type == .anonymous) {
                    Button(action: {
                        navigator.navigate(to: .profile)
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
