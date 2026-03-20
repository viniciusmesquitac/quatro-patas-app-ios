//
//  QuantitySelectorView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct QuantitySelectorView: View {
    
    @Binding var value: Double
    
    var body: some View {
        HStack(spacing: 30) {
            
            // Botão -
            Button(action: {
                if value > 1 {
                    value -= 1
                }
            }) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .overlay(
                        SFIcon.image(.decrease, color: .customLabel)
                            .font(.system(size: 28, weight: .bold))
                    )
            }
            
            // Valor
            Text(value, format: .currency(code: "BRL"))
                .font(.system(size: 32, weight: .bold))
                .minimumScaleFactor(0.5)
            
            // Botão +
            Button(action: {
                value += 1
            }) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .overlay(
                        SFIcon.image(.add, color: .customLabel)
                            .font(.system(size: 28, weight: .bold))
                    )
            }
        }
    }
}
