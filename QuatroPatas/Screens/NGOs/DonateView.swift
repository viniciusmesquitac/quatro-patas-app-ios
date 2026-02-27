//
//  DonateView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct DonateView: View {
    @EnvironmentObject var navigator: Navigator
    @Environment(\.toast) var toast

    @State private var amount: Double = 5.0

    let pixKey: String
    let merchantName: String
    let merchantCity: String

    var body: some View {
        VStack(spacing: Spacing.large.rawValue) {
            HStack {
                Text("Doação")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.leading, Padding.small.rawValue)
                Spacer()
            }
            
            Text("Faça uma doação para ajudar essa causa. Qualquer ajuda é bem vinda.")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
    
            QuantitySelectorView(value: $amount)
            PresetAmountSelectorView(selectedAmount: $amount)
                .padding(.horizontal, Padding.medium.rawValue)

            Button("Copiar Pix") {
                navigator.dismiss()
                let payload = PixBRCode.generatePayload(
                    pixKey: pixKey,
                    merchantName: merchantName,
                    merchantCity: merchantCity,
                    amount: Decimal(amount)
                )
                UIPasteboard.general.string = payload
                print(payload)
                toast("Chave pix copiada com sucesso!", .success)
            }
            .padding(.horizontal, Padding.small.rawValue)
            .buttonStyle(PrimaryButtonStyle())
        }
        .interactiveDismissDisabled(false)
        .presentationDetents([.fraction(0.5)])
        .presentationBackground(Color.customBackground)
        .presentationCornerRadius(24)
        .padding()
    }
}
