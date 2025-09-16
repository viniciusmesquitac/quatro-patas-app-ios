//
//  View+If.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/09/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool,
                             transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
