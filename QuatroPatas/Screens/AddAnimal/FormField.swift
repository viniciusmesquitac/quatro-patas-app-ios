//
//  FormField.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/09/25.
//

import SwiftUI

struct FormField<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).bold()
            content()
        }
    }
}
