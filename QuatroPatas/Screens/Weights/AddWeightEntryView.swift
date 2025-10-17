//
//  AddWeightEntryView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/10/25.
//

import SwiftUI

struct AddWeightEntryView: View {

    @State private var selectedDate = Date()
    @State private var weightText = ""
    @State private var isLoading: Bool = false

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var firestoreProvider: DatabaseProvider
    
    @Environment(\.toast) var toast
    
    var animalId: String
    var onAdded: ((WeightEntry) -> Void)

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.medium.rawValue) {
                DatePicker("Data", selection: $selectedDate, displayedComponents: .date)
                
                TextField("Peso (kg)", text: $weightText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                .buttonStyle(.borderedProminent)
                Spacer()
            }
        }
        .navigationTitle("Adicionar Registro")
        .padding(.horizontal, Padding.large.rawValue)
        .toolbarItem(label: "Fechar", placement: .topBarTrailing) {
            navigator.dismiss()
        }
        .safeAreaInset(edge: .bottom) {
            Button("Adicionar registro") {
                if let weight = Double(weightText.replacingOccurrences(of: ",", with: ".")) {
                    addEntry(date: selectedDate, weight: weight)
                }
            }
            .padding(.horizontal, Padding.large.rawValue)
            .buttonStyle(PrimaryButtonStyle())
        }
    }

    func addEntry(date: Date, weight: Double) {
        let weight = WeightEntry(date: date, weight: weight)
        guard let userId = userSession.user?.id else { return }
        let path = "users/\(userId)/animals/\(animalId)/weights"

        Task {
            do {
                _ = try await firestoreProvider.add(weight, to: path)
                isLoading = false
                toast("Vacina adicionada com sucesso!", .success)
                onAdded(weight)
                navigator.dismiss()
            } catch {
                isLoading = false
                toast(error.localizedDescription, .error)
            }
        }
    }
}
