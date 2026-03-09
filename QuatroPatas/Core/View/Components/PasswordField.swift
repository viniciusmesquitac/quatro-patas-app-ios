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

    var isInvalid: Bool = false
    var height: CGFloat = 52

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
                SFIcon.image( isVisible ? .eye_close : .eye_open)
                    .foregroundColor(.gray.opacity(0.8))
                    .frame(width: 44, height: height)
            }
            .padding(.trailing, 4)
        }
    }
}
