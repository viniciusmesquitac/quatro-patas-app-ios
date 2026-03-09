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
            Spacer()
            List(filtered) { item in
                Button {
                    if item.isDefault {
                        useCurrentLocation()
                    } else {
                        location = "\(item.city), \(item.state)"
                        dismiss()
                    }
                } label: {
                    HStack(spacing: Spacing.medium.rawValue) {
                        if item.isDefault {
                            SFIcon.image(.location)
                                .foregroundStyle(item.isDefault ? .blue : .secondary)
                        } else {
                            SFIcon.image(.pin)
                                .foregroundStyle(item.isDefault ? .blue : .secondary)
                        }

                        VStack(alignment: .leading) {
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
                    .contentShape(Rectangle())
                }
                .disabled(item.isDefault && isResolvingCurrentLocation)
            }
            .listStyle(.plain)
            .toolbarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .background(Color.customBackground)
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
