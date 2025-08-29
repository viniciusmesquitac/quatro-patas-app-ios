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
            Image(systemName: toast?.type == .success ? "checkmark.circle.fill" : "xmark.octagon.fill")
                .foregroundColor(.white)
                .font(.title2)
            
            Text(toast?.message ?? String())
                .foregroundColor(.white)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(toast?.type == .success ? Color.green : Color.red)
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
}
