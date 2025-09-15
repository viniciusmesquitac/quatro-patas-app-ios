//
//  PrimaryTextFieldStyle.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 13/09/25.
//


import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(CornerRadius.large.rawValue)
            .textInputAutocapitalization(.none)
    }
}
