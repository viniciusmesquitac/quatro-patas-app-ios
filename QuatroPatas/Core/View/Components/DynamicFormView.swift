//
//  DynamicFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/09/25.
//

import SwiftUI

struct DynamicFormView: View {
    let elements: [FormElement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
            ForEach(elements) { element in
                switch element {
                case .textField(let title, let placeholder, let binding, let keyboard):
                    FormField(title: title) {
                        TextField(placeholder, text: binding)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(keyboard)
                    }
                    
                case .textEditor(let title, let binding):
                    FormField(title: title) {
                        TextEditor(text: binding)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                case .selectable(let title, let options, let binding):
                    FormField(title: title) {
                        HStack {
                            ForEach(options, id: \.self) { option in
                                SelectableButton(title: option, isSelected: binding.wrappedValue == option) {
                                    binding.wrappedValue = option
                                }
                            }
                        }
                    }
                    
                case .multiselection(let title, let options, let binding):
                    FormField(title: title) {
                        DropdownView(options: options, mode: .multiple(binding: binding))
                    }

                case .dropdown(let title, let options, let binding):
                    FormField(title: title) {
                        DropdownView(options: options, mode: .single(binding: binding))
                    }
                case .agePicker(years: let years, months: let months):
                    FormField(title: "Idade") {
                        AgePickerView(years: years, months: months)
                    }
                }
            }
        }
    }
}
