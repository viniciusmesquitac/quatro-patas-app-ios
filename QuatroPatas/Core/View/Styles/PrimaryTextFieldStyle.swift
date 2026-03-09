//
//  PrimaryTextFieldStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//


import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {

    var height: CGFloat = 52
    var isInvalid: Bool = false

    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1.5)
            )
            .cornerRadius(CornerRadius.large.rawValue)
            .textInputAutocapitalization(.none)
    }
}
