//
//  CustomDatePicker.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/10/25.
//

import SwiftUI

struct CustomDatePicker: View {

    @Binding var answer: String
    
    var body: some View {
        HStack {
            Text("data: ")
            Spacer()
            DatePicker(
                "Selecione uma data",
                selection: Binding(
                    get: {
                        // converte a string atual para Date, se possível
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        return formatter.date(from: answer) ?? Date()
                    },
                    set: { newDate in
                        // formata a nova data em string e atualiza o answer
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        answer = formatter.string(from: newDate)
                    }
                ),
                displayedComponents: [.date]
            )
            .labelsHidden()
            .datePickerStyle(.compact)
        }

    }
}
