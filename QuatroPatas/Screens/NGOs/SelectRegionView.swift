//
//  SelectRegionView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI
import CoreLocation

struct SelectRegionView: View {
    @Environment(\.dismiss) private var dismiss

    private let places: [Place] = [
        .init(city: "Default", state: "Default"),
        .init(city: "Fortaleza", state: "CE"),
        .init(city: "Caucaia", state: "CE"),
        .init(city: "São Paulo", state: "SP"),
        .init(city: "Rio de Janeiro", state: "RJ")
    ]

    @State private var searchText = ""
    @Binding var location: String

    @StateObject private var locationManager = LocationManager()
    @State private var isResolvingCurrentLocation = false
    @Environment(\.toast) var toast

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
                    if item.isDefault {
                        useCurrentLocation()
                    } else {
                        location = "\(item.city), \(item.state)"
                        dismiss()
                    }
                } label: {
                    HStack(spacing: 12) {

                        // Ícone à esquerda
                        if item.isDefault {
                            Image(systemName: "location.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(item.isDefault ? .blue : .secondary)
                                .frame(width: 26)
                        } else {
                            Image(systemName: "pin")
                                .resizable()
                                .frame(width: 16, height: 18)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(item.isDefault ? .blue : .secondary)
                                .frame(width: 26)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            if item.isDefault {
                                Text("Utilizar localização atual")
                                    .font(.body)
                                    .foregroundStyle(Color.customLabel)

                                Text("Autorizar uso de GPS")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            } else {
                                Text(item.city)
                                    .font(.body)
                                    .foregroundStyle(Color.customLabel)

                                Text(item.state)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }

                        Spacer()

                        if item.isDefault && isResolvingCurrentLocation {
                            LoadingView()
                        }
                    }
                    .contentShape(Rectangle()) // deixa a linha inteira clicável
                }
                .disabled(item.isDefault && isResolvingCurrentLocation)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(.plain)
            .toolbarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(Color.customBackground)
            .toolbarItem(icon: .close, placement: .topBarTrailing) {
                dismiss()
            }
            .navigationTitle("Região")
        }
    }

    private func useCurrentLocation() {
        locationManager.requestLocation()

        Task {
            do {
                let cityUF = try await locationManager.getCityStateString()
                location = cityUF
                dismiss()
            } catch {
                toast(error.localizedDescription, .error)
            }
        }
    }
}
