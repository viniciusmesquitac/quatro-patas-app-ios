//
//  AnimalTypeBadge.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/03/26.
//


import SwiftUI

struct AnimalTypeBadge: View {
    let type: String

    var body: some View {
        HStack(spacing: 6) {
            Text(icon)
            Text(title)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }

    private var title: String {
        switch type.lowercased() {
        case "dog", "cão", "cachorro":
            return "Cão"
        case "cat", "gato":
            return "Gato"
        default:
            return "Pet"
        }
    }

    private var icon: String {
        switch type.lowercased() {
        case "dog", "cão", "cachorro":
            return "🐶"
        case "cat", "gato":
            return "🐱"
        default:
            return "🐾"
        }
    }
}
