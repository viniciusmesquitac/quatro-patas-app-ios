//
//  AdoptionView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/05/25.
//

import SwiftUI

struct AdoptionView: View {

    @State private var adoptionTips: [AdoptionTip] = [
        AdoptionTip(title: "TESTE 1", subtitle: "Como adotar", description: "Como adotar 1"),
        AdoptionTip(title: "TESTE 2", subtitle: "Como adotar", description: "Como adotar 2"),
        AdoptionTip(title: "TESTE 3", subtitle: "Como adotar", description: "Como adotar 3")
    ]

    @State private var happyEndings: [HappyEnding] = [
        .init(imageUrl: "https://firebasestorage.googleapis.com/v0/b/quatropatas-a8f96.firebasestorage.app/o/animals%2F6D9442FA-0AF1-49E6-BBDF-57D481C9AB84%2F8C8584D4-20B9-48AE-8C38-9E9DEE524496.jpg?alt=media&token=0c5d7e66-6761-405d-85a2-d444382a7918",
              title: "teste",
              description: "teste"),
        .init(imageUrl: "https://firebasestorage.googleapis.com/v0/b/quatropatas-a8f96.firebasestorage.app/o/animals%2F6D9442FA-0AF1-49E6-BBDF-57D481C9AB84%2F8C8584D4-20B9-48AE-8C38-9E9DEE524496.jpg?alt=media&token=0c5d7e66-6761-405d-85a2-d444382a7918",
              title: "teste",
              description: "teste")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Finais Felizes")
                    .font(.subheadline)
                    .padding(.horizontal, 24)
                
                HappyEndingCard(happyEndings: happyEndings)
                
                Text("Dicas")
                    .font(.subheadline)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)
                
                ForEach(adoptionTips) { tip in
                    tipCard(tip)
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle("Adoção")
    }
    
    @ViewBuilder
    private func tipCard(_ tip: AdoptionTip) -> some View {
        Button {
            print("Tap Detail")
        } label: {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(.systemGray6))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(tip.title)
                        .font(.headline)
                    
                    Text(tip.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding()
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
