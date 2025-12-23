//
//  NetworkBannerView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/12/25.
//

import SwiftUI

struct NetworkBannerView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .imageScale(.medium)
            Text("Sem conexão com a internet")
                .font(.subheadline.bold())
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Color.red.opacity(0.95))
        .foregroundColor(.white)
        .shadow(radius: 4)
    }
}
