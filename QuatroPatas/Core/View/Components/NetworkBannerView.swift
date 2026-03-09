//
//  NetworkBannerView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/12/25.
//

import SwiftUI

struct NetworkBannerView: View {
    @State private var isVisible = true

    var body: some View {
        if isVisible {
            HStack(spacing: 12) {
                SFIcon.image(.wifi)
                    .imageScale(.medium)

                Text("Sem conexão com a internet")
                    .font(.subheadline.bold())

                Spacer()

                Button {
                    withAnimation(.easeOut) {
                        isVisible = false
                    }
                } label: {
                    SFIcon.image(.close)
                        .font(.system(size: 14, weight: .bold))
                        .padding(6)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.red.opacity(0.85))
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            .padding(.horizontal)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}
