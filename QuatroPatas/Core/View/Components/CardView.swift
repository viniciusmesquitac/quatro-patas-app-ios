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
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Color.primaryColor
                    .cornerRadius(CornerRadius.medium.rawValue)

                VStack {
                    HStack {
                        Image(systemName: icon.rawValue)
                            .font(.system(size: 22))
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(title)
                            .foregroundStyle(Color.white)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 162)
        }
        .buttonStyle(CardButtonStyle())
    }
}
