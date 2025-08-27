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
        }){
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
        .foregroundColor(.secundaryColor)
        .padding()
        .background(Color.primaryColor)
        .cornerRadius(CornerRadius.medium.rawValue)
    }
}
    
