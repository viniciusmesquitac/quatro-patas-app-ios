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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

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
                .padding()
                
                if let buttonText = tip.buttonText {
                    Button(action: {
                        tip.buttonAction?()
                    }) {
                        Text(buttonText)
                    }.buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding()
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                navigator.dismiss()
            }
        }
    }
}
