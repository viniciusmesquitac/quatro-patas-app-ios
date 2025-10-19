//
//  WebViewPopup.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 18/10/25.
//

import SwiftUI

struct WebViewPopup {
    let title: String
    let description: String
    let buttons: [PopupButton]

    var didTapButton: ((String) -> Void)? =  nil
}

struct PopupButton: Identifiable {
    var id = UUID()
    var text: String
    var role: ButtonRole? = .none
}
