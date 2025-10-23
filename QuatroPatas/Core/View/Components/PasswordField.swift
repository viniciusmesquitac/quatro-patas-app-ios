//
//  PasswordField.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 23/10/25.
//

import SwiftUI

struct PasswordField: View {
    let title: String
    @Binding var text: String

    @State private var isVisible: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isVisible {
                    TextField(title, text: $text)
                        .textFieldStyle(PrimaryTextFieldStyle())
                } else {
                    SecureField(title, text: $text)
                        .textFieldStyle(PrimaryTextFieldStyle())
                }
            }

            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray.opacity(0.8))
                    .padding(.trailing, Padding.large.rawValue)
            }
        }
    }
}
