//
//  BackButtonModifier.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI

struct BackButtonToolbarModifier: ViewModifier {
    @EnvironmentObject var navigator: Navigator
    var label: String?
    var data: Any? = nil
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigator.dismiss(with: data)
                    }) {
                        HStack {
                            SFIcons.image(.back)
                            if let label = label {
                                Text(label)
                            }
                        }
                    }
                }
            }
    }
}
