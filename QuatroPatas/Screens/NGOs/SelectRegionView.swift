//
//  SelectRegionView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct SelectRegionView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let places: [Place] = [
        .init(city: "Fortaleza", state: "CE"),
        .init(city: "Caucaia", state: "CE"),
        .init(city: "São Paulo", state: "SP"),
        .init(city: "Rio de Janeiro", state: "RJ")
    ]

    @State private var searchText = ""
    @Binding var location:  String

    private var filtered: [Place] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return places }

        let qLower = q.lowercased()

        return places.filter { item in
            item.city.lowercased().contains(qLower) ||
            item.state.lowercased().contains(qLower) ||
            "\(item.city) \(item.state)".lowercased().contains(qLower)
        }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { item in
                Button {
                    location = item.city + ", " + item.state
                    dismiss()
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.city)
                            .font(.body)
                            .foregroundStyle(Color.customLabel)
                        Text(item.state)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.customBackground)
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                dismiss()
            }
            .navigationTitle("Região")
        }
    }
}
