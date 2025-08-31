//
//  AdoptionView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct AdoptionView: View {
    @EnvironmentObject private var navigator: Navigator
    
    let adoptionTip = Tip(
        title: "dicas",
        description: [
            TextFragment(content: "dicas", isBold: true)
        ]
    )

    var body: some View {
        ScrollView {
            
        }
        .navigationTitle(AppTab.localized(.adoption))
        .toolbarItem(icon: .tip) {
            navigator.present(sheet: .tip(adoptionTip))
        }
    }
}
