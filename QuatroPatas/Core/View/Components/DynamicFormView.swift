//
//  DynamicFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/09/25.
//

import SwiftUI

struct DynamicFormView: View {
    let elements: [FormElement]
    @EnvironmentObject var navigator: Navigator
    @Environment(\.toast) var toast
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
            ForEach(elements) { element in
                switch element {
                case .textField(let title, let placeholder, let binding, _):
                    FormField(title: title) {
                        NoDropTextField(text: binding, placeholder: placeholder)
                            .frame(height: 48)
                    }
                    
                case .textEditor(let title, let binding, let showGenerator):
                    VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                        HStack {
                            Text(title).font(.headline).bold()
                            Spacer()
                            if showGenerator {
                                Button("Gerar automáticamente") {
                                    AnimalDescriptionGenerator.generate(for: binding) { message in
                                        toast(message, .error)
                                    }
                                }
                            }
                        }
                        TextEditorButton(text: binding.description) {
                            navigator.present(sheet: .descriptionEditor(binding.description))
                        }
                        Spacer()
                    }
                    
                case .selectable(let title, let options, let binding):
                    FormField(title: title) {
                        HStack {
                            ForEach(options, id: \.self) { option in
                                SelectableButton(title: option, isSelected: binding.wrappedValue == option) {
                                    binding.wrappedValue = option
                                    isTextFieldFocused = false
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
                    
                case .locationPicker(let title, let binding):
                    FormField(title: title) {
                        LocationPickerView(address: binding)
                    }
                }
            }
        }
    }
}

struct FormField<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
            Text(title).font(.headline).bold()
            content()
            Spacer()
        }
    }
}
