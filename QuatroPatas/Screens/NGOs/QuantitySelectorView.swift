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
                if value > 0 {
                    value -= 1
                }
            }) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "minus")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                    )
            }
            
            // Valor
            Text(value, format: .currency(code: "BRL"))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
                .minimumScaleFactor(0.5)
            
            // Botão +
            Button(action: {
                value += 1
            }) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                    )
            }
        }
    }
}
