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
                TextField(question.placeholder ?? "Digite sua resposta", text: $answer)
                    .onChange(of: answer) { _, newValue in
                        answer = newValue
                        if answer.count > 0 {
                            formManager.errors.remove(question.id)
                        } else {
                            formManager.errors.insert(question.id)
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
                    )
                
            case .email:
                TextField("Digite seu email", text: $answer)
                    .onChange(of: answer) { _, newValue in
                        answer = newValue
                        if answer.count > 0 {
                            formManager.errors.remove(question.id)
                        } else {
                            formManager.errors.insert(question.id)
                        }
                    }
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
                    )

            case .age:
                TextField("Digite sua idade", text: $answer)
                    .onChange(of: answer) { _, newValue in
                        answer = newValue
                        if answer.count > 0 {
                            formManager.errors.remove(question.id)
                        } else {
                            formManager.errors.insert(question.id)
                        }
                    }
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
                    )
            case .phone:
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
                        if !digits.isEmpty {
                            formManager.errors.remove(question.id)
                        } else {
                            formManager.errors.insert(question.id)
                        }
                    }
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
                    )

            case .longAnswer:
                TextEditor(text: $answer)
                    .onChange(of: answer) { _, newValue in
                        answer = newValue
                        if answer.count > 0 {
                            formManager.errors.remove(question.id)
                        } else {
                            formManager.errors.insert(question.id)
                        }
                    }
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isInvalid ? Color.red : Color.gray.opacity(0.4))
                    )

            case .singleSelection:
                if let options = question.options {
                    ForEach(options, id: \.self) { title in
                        option(title: title, selection: $answer)
                    }
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
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
            HStack {
                Image(systemName: selection.wrappedValue == title ? SFIcon.circle_filled.rawValue : SFIcon.circle.rawValue)
                    .foregroundColor(selection.wrappedValue == title ? .primaryColor : .secondary)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(NoneButtonStyle())
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
