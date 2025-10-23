//
//  ConfirmDeleteView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 23/10/25.
//

import SwiftUI

struct ConfirmDialogModel {
    let title: String
    let message: String
    let confirmButtonTitle: String
    let cancelButtonTitle: String
    let onConfirm: () -> Void

    init(
        title: String,
        message: String,
        confirmButtonTitle: String = "Confirmar",
        cancelButtonTitle: String = "Cancelar",
        onConfirm: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmButtonTitle = confirmButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        self.onConfirm = onConfirm
    }
}

struct ConfirmDeleteView: View {
    @EnvironmentObject var navigator: Navigator
    let model: ConfirmDialogModel

    
    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            VStack(spacing: Spacing.small.rawValue) {

                Text(model.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(model.message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            
            Button(model.confirmButtonTitle) {
                navigator.dismiss()
                model.onConfirm()
            }
            .buttonStyle(PrimaryButtonStyle())
            .tint(.red)
            
            Button(model.cancelButtonTitle) {
                navigator.dismiss()
            }
            .buttonStyle(OutlineRoundedButtonStyle())
        }
        .interactiveDismissDisabled(false)
        .presentationDetents([.fraction(0.32)])
        .presentationCornerRadius(24)
        .padding()
    }
}
