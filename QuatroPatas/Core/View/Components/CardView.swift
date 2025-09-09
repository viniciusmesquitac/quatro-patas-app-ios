//
//  CardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 23/08/25.
//

import SwiftUI

struct CardView: View {

    var title: String
    var icon: SFIcon = .paw
    var route: Route
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        Button(action: {
            navigator.navigate(to: route)
        }) {
            VStack {
                HStack {
                    Image(systemName: icon.rawValue)
                        .font(.system(size: 22))
                        .foregroundStyle(Color.neutralWhite)
                    Spacer()
                }
                Spacer()
                HStack {
                    Text(title)
                        .foregroundStyle(Color.neutralWhite)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
            .background {
                Color.primaryColor
                    .cornerRadius(CornerRadius.medium.rawValue)
            }
        }
        .buttonStyle(CardButtonStyle())
    }

}
