//
//  TipView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/08/25.
//

import SwiftUI

struct TipView: View {
    
    @EnvironmentObject var navigator: Navigator
    var title: String
    var descripition: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(descripition)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
            }
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                navigator.dismiss()
            }
        }
    }
}
