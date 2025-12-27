//
//  FloatingBorderLabelTextField.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/12/25.
//


import SwiftUI

struct FloatingBorderLabelTextField: View {
    let placeholder: String
    var disabled: Bool = false
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    private var shouldFloat: Bool {
        isFocused || !text.isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            // Borda
            RoundedRectangle(cornerRadius: 24)
                .stroke(isFocused ? Color.primaryColor : Color.gray.opacity(0.3),
                        lineWidth: 1.5)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemBackground))
                )
                .frame(height: 56)
            
            // Label flutuante
            Text(placeholder)
                .font(.system(size: shouldFloat ? 12 : 16, weight: .medium))
                .foregroundColor(isFocused ? Color.primaryColor : .gray)
                .padding(.horizontal, 6)
                .background(Color(.systemBackground))
                .offset(x: 16, y: shouldFloat ? -28 : 0)
                .scaleEffect(shouldFloat ? 0.95 : 1.0, anchor: .leading)
                .animation(.spring(response: 0.35, dampingFraction: 0.85),
                           value: shouldFloat)
            
            // TextField real
            TextField("", text: $text)
                .padding(.horizontal, 18)
                .frame(height: 56)
                .focused($isFocused)
                .disabled(disabled)
                .foregroundStyle(disabled ? Color.gray : Color.customLabel)
        }
    }
}
