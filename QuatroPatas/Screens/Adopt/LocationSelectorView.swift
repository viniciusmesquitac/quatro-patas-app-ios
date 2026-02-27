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
            HStack(spacing: 8) {
                
                // Ícone esquerdo
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 18))
                
                // Texto
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                
                // Ícone direito
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                
            }
            .foregroundColor(.primary)
        }
        .buttonStyle(.plain)
    }
}
