//
//  AdoptionView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct AdoptionView: View {
    @EnvironmentObject private var navigator: Navigator

    var body: some View {
        ScrollView {
            
        }
        .navigationTitle(AppTab.localized(.adoption))
        .toolbarItem(icon: .tip) {
            navigator.present(sheet: .tip(Tip(title: "dicas", descripition: "dicas")))
        }
    }
}
