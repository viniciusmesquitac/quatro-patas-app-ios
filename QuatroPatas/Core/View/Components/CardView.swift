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
    var isFocused: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack {
                if isFocused {
                    Color.primaryColor
                        .cornerRadius(CornerRadius.medium.rawValue)
                } else {
                    Color.customBackground
                        .cornerRadius(CornerRadius.medium.rawValue)
                }

                VStack {
                    HStack {
                        Image(systemName: icon.rawValue)
                            .font(.system(size: 22))
                            .foregroundStyle(isFocused ? Color.customBackground : Color.primaryColor)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(title)
                            .foregroundStyle(isFocused ? Color.customBackground : Color.customLabel)
                            .font(.headline)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding()
            }
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
            .frame(maxWidth: .infinity, minHeight: 162)
        }
        .buttonStyle(CardButtonStyle())
    }
}
