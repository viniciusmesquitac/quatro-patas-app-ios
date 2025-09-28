//
//  VaccinePicker.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/09/25.
//


import SwiftUI

struct VaccinePicker: View {
    @Binding var selectedVaccine: String?

    let vaccines = [
        "Tríplice (V3)",
        "Quádrupla (V4)",
        "Quíntupla (V5)",
        "V8",
        "V10",
        "Antirrábica",
        "BronchiGuard"
    ]

    var body: some View {
        Picker("Vacina", selection: $selectedVaccine) {
            Text("Selecione").tag(nil as String?)

            ForEach(vaccines, id: \.self) { vaccine in
                Text(vaccine).tag(vaccine as String?)
            }

            Text("Outro").tag("Outro" as String?)
        }
        .pickerStyle(.menu)
    }
}
