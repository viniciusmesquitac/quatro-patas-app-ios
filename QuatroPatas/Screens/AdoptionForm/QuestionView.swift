//
//  QuestionView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    @Binding var answer: String
    @EnvironmentObject var formManager: FormManager
    
    let columns = [
        GridItem(.flexible(), spacing: Spacing.large.rawValue),
        GridItem(.flexible(), spacing: Spacing.large.rawValue)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question.title)
                .font(.headline)
                .foregroundColor(isInvalid ? .red : .primary) // título vermelho se inválido
            
            if let subtitle = question.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            switch question.type {
            case .shortAnswer:
                shortAnwerTextField
            case .email:
               emailTextField
            case .age:
                ageTextField
            case .phone:
                phoneTextField
            case .longAnswer:
                longAnswerTextField
            case .singleSelection:
                if let options = question.options {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: Spacing.xLarge.rawValue) {
                            ForEach(options, id: \.self) { title in
                                SelectableCardView(
                                    title: title,
                                    selection: $answer,
                                    questionId: question.id,
                                    formManager: formManager
                                )
                                .frame(minHeight: 162)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
            case .location:
                LocationPickerView(address: $answer)
            case .date:
                CustomDatePicker(answer: $answer)
            case .imageUpload:
                ImageUploadField(answer: $answer)
            }
            
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Views
    
    var longAnswerTextField: some View {
        TextEditor(text: $answer)
            .onChange(of: answer) { _, newValue in
                answer = newValue
                if answer.count > 0 {
                    formManager.errors.remove(question.id)
                } else {
                    formManager.errors.insert(question.id)
                }
            }
            .primaryTextEditorStyle()
            .frame(minHeight: 100)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(isInvalid ? Color.red : Color.gray.opacity(0.4))
            )
    }
    
    var ageTextField: some View {
        TextField("Digite sua idade", text: $answer)
            .onChange(of: answer) { _, newValue in
                answer = newValue
                if answer.count > 0 || !Validator.isValidAge(answer) {
                    formManager.errors.remove(question.id)
                } else {
                    formManager.errors.insert(question.id)
                }
            }
            .keyboardType(.numberPad)
            .textFieldStyle(PrimaryTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
            )
    }
    
    var shortAnwerTextField: some View {
        TextField(question.placeholder ?? "Digite sua resposta", text: $answer)
            .onChange(of: answer) { _, newValue in
                answer = newValue
                if answer.count > 0 {
                    formManager.errors.remove(question.id)
                } else {
                    formManager.errors.insert(question.id)
                }
            }
            .textFieldStyle(PrimaryTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
            )
    }
    
    var emailTextField: some View {
        TextField("Digite seu email", text: $answer)
            .onChange(of: answer) { _, newValue in
                answer = newValue
                if answer.count > 0 || !Validator.isValidEmail(answer) {
                    formManager.errors.remove(question.id)
                } else {
                    formManager.errors.insert(question.id)
                }
            }
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .textFieldStyle(PrimaryTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
            )
    }
    
    var phoneTextField: some View {
        TextField("Digite seu telefone", text: $answer)
            .onChange(of: answer) { _, newValue in
                // só números
                var digits = newValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                
                // limita a no máximo 11 dígitos
                if digits.count > 11 {
                    digits = String(digits.prefix(11))
                }
                
                // aplica máscara
                answer = PhoneFormatter.applyMask(digits)
                
                // validação dinâmica
                if !digits.isEmpty || !Validator.isValidPhone(answer) {
                    formManager.errors.remove(question.id)
                } else {
                    formManager.errors.insert(question.id)
                }
            }
            .keyboardType(.numberPad)
            .textFieldStyle(PrimaryTextFieldStyle())
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
            )
    }
    
    // MARK: - Validações
    
    private var isInvalid: Bool {
        guard formManager.didSubmit else { return false }
        return formManager.errors.contains(question.id)
    }
    
    private var errorMessage: String? {
        guard answer.count > 0 else {
            return isInvalid ? "Este campo é obrigatório" : nil
        }
        switch question.type {
        case .email:
            return Validator.isValidEmail(answer) ? nil : "Digite um email válido"
        case .age:
            return Validator.isValidAge(answer) ? nil : "A idade deve ser maior que 21 anos"
        case .phone:
            return Validator.isValidPhone(answer) ? nil : "Número de telefone inválido"
        default:
            return isInvalid ? "Este campo é obrigatório" : nil
        }
    }
    
    @ViewBuilder
    func option(title: String, selection: Binding<String>) -> some View {
        Button(action: {
            selection.wrappedValue = title
            formManager.errors.remove(question.id) // remove erro ao responder
        }) {
            Text(title)
                .foregroundColor(.primary)
                .contentShape(Rectangle())
        }
        .buttonStyle(CardButtonStyle())
    }
}


/// MARK: - Validador Auxiliar
struct Validator {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    static func isValidAge(_ text: String) -> Bool {
        if let age = Int(text) {
            return age >= 21
        }
        return false
    }
    
    static func isValidPhone(_ text: String) -> Bool {
        let digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return digits.count == 10 || digits.count == 11
    }
}
