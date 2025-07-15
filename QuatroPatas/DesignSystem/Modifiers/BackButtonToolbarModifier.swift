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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            if let label = label {
                                Text(label)
                            }
                        }
                    }
                }
            }
    }
}
