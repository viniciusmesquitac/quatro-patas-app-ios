//
//  NotificationOptionsSelector.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/09/25.
//

import SwiftUI

struct NotificationOptionsSelector: View {
    @Binding var sendNotification: Bool
    @Binding var selectedOptions: Set<NotificationOption>
    
    var body: some View {
        Toggle("Receber notificações", isOn: $sendNotification)
        
        if sendNotification {
            VStack(alignment: .leading, spacing: 8) {
                Text("Quando lembrar?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Aqui cada linha usa o set corretamente
                ForEach(NotificationOption.allCases) { option in
                    MultipleSelectionRow(
                        title: option.rawValue,
                        isSelected: selectedOptions.contains(option)
                    ) {
                        toggle(option)
                    }
                }
            }
        }
    }

    private func toggle(_ option: NotificationOption) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }
    }
}

// MARK: - Linha
private struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .buttonStyle(SelectionRowButtonStyle(isSelected: isSelected))
    }
}
