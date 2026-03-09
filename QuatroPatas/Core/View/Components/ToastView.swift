//
//  ToastView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI

struct ToastView: View {
    @Binding var toast: ToastItem?

    var body: some View {
        HStack {
            SFIcon.image(icon(for: toast?.type), color: .white)
                .font(.title2)

            Text(toast?.message ?? "")
                .foregroundColor(.white)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor(for: toast?.type))
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal, 24)
        .task(id: toast?.id) {
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }
            withAnimation(.bouncy) {
                toast = nil
            }
        }
    }

    // MARK: - Helpers

    private func backgroundColor(for type: ToastType?) -> Color {
        switch type {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .none: return .clear
        }
    }

    private func icon(for type: ToastType?) -> SFIcon {
        switch type {
        case .success: return .success
        case .error: return .failure
        case .warning: return .warning
        case .none: return .about
        }
    }
}
