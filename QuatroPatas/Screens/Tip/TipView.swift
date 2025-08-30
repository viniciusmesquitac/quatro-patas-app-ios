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
                    
                    Text(tip.descripition)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }.padding()
                
                if tip.buttonText != nil {
                    Button(action: {
                        tip.buttonAction?()
                    }) {
                        Text(tip.buttonText ?? String())
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .center))
                            .background(Color.primaryColor)
                    }
                }
            }
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                navigator.dismiss()
            }
        }
    }
}
