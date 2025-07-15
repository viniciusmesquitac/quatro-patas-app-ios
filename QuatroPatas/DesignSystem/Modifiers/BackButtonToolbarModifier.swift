//
//  BackButtonModifier.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct BackButtonToolbarModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    var label: String?

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .backButton()
    }
}
