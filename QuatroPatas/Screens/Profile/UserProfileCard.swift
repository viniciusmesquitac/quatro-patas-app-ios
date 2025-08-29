//
//  UserProfileCard.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/08/25.
//

import SwiftUI

struct UserProfileCard: View {
    @State var name: String
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        Button(action: {
            navigator.navigate(to: .adoption)
        }) {
            HStack {
                Image(systemName: SFIcon.person.rawValue)
                    .resizable()
                    .frame(width: 64, height: 64)

                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                    Text("ver perfil")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity) // largura total
            .background(Color.primaryColor)
            .cornerRadius(CornerRadius.medium.rawValue)
        }
        .foregroundColor(.secundaryColor)
        .buttonStyle(.plain) // mantém sem highlight azul
        .contentShape(Rectangle()) // garante que toda a área seja clicável
    }
}
