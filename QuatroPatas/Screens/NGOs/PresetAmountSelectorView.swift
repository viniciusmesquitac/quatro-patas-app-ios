//
//  PresetAmountSelectorView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct PresetAmountSelectorView: View {
    
    @Binding var selectedAmount: Double
    
    let values: [Double] = [20, 50, 100]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(values, id: \.self) { value in
                Button {
                    selectedAmount = value
                } label: {
                    Text("R$ \(Int(value))")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedAmount == value
                            ? Color.primaryColor
                            : Color.gray.opacity(0.15)
                        )
                        .foregroundColor(
                            selectedAmount == value
                            ? .white
                            : .primary
                        )
                        .cornerRadius(12)
                }
            }
        }
    }
}
