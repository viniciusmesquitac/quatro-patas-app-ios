//
//  CardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 23/08/25.
//

import SwiftUI

struct CardView<T: Localizable>: View {

    var title: T
    var route: Route
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        Button(action: {
            navigator.navigate(to: route)
        }) {
            Text(T.localized(title))
                .foregroundStyle(Color.secundaryColor)
                .frame(maxWidth: .infinity, minHeight: 150)
                .padding()
                .background(Color.primaryColor)
                .cornerRadius(CornerRadius.medium.rawValue)
        }
        .buttonStyle(CardButtonStyle())
    }
}
