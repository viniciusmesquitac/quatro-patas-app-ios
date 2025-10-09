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
            Image(systemName: iconName(for: toast?.type))
                .foregroundColor(.white)
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

    private func iconName(for type: ToastType?) -> String {
        switch type {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .none: return "info.circle"
        }
    }
}
