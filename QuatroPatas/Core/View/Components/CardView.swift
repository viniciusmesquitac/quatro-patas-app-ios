//
//  CardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 23/08/25.
//

import SwiftUI

struct CardView<T: Localizable>: View {

    var title: T
    var icon: SFIcon = .paw
    var route: Route
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        Button(action: {
            navigator.navigate(to: route)
        }) {
            ZStack {
                // Fundo do card
                Color.primaryColor
                    .cornerRadius(CornerRadius.medium.rawValue)

                VStack {
                    HStack {
                        Image(systemName: icon.rawValue)
                            .font(.system(size: 22))
                            .foregroundStyle(Color.secundaryColor)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(T.localized(title))
                            .foregroundStyle(Color.secundaryColor)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 150)
        }
        .buttonStyle(CardButtonStyle())
    }
}
