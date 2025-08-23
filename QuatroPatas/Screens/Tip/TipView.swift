//
//  TipView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/08/25.
//

import SwiftUI

struct TipView: View {
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        NavigationStack {
            Form {
                Section("tips") {
                    
                }
            }.toolbarItem(icon: .close, placement: .topBarTrailing) {
                navigator.dismiss()
            }
        }
    }
    
}
