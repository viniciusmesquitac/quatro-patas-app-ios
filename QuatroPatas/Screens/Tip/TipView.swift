//
//  TipView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/08/25.
//

import SwiftUI

struct TipView: View {
    
    @EnvironmentObject var navigator: Navigator
    var tip: Tip

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.xxLarge.rawValue) {

                    Text(tip.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    ForEach(tip.description) { fragment in
                        Text(fragment.content)
                            .fontWeight(fragment.isBold ? .bold : .regular)
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal, Padding.large.rawValue)
                
                if let buttonText = tip.buttonText {
                    Button(action: {
                        tip.buttonAction?()
                    }) {
                        Text(buttonText)
                    }
                    .padding(.horizontal, Padding.large.rawValue)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                navigator.dismiss()
            }
        }
    }
}
