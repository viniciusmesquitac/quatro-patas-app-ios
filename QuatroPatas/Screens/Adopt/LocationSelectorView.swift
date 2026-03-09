//
//  LocationSelectorView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/02/26.
//

import SwiftUI

struct LocationSelectorView: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.small.rawValue) {
                
                // Texto
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                
                // Ícone direito
                SFIcon.image(.arrow_down, color: .gray)
                    .font(.system(size: 14, weight: .semibold))
                
            }
            .foregroundColor(.primary)
        }
        .buttonStyle(.plain)
    }
}
