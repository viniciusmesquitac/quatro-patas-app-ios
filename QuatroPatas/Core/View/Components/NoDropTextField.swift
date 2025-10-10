//
//  NoDropTextField.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 09/10/25.
//

import SwiftUI

struct NoDropTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator

        // Estilo visual igual ao PrimaryTextFieldStyle
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.15)
        textField.layer.cornerRadius = CGFloat(CornerRadius.medium.rawValue)
        textField.layer.masksToBounds = true
        textField.textAlignment = .left
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Padding interno (para imitar o .padding() do SwiftUI)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        // Desabilita interação de drop
        textField.textDragInteraction?.isEnabled = false
        textField.textDropDelegate = context.coordinator

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate, UITextDropDelegate {
        var parent: NoDropTextField

        init(_ parent: NoDropTextField) {
            self.parent = parent
        }

        // Impede qualquer drop de texto
        func textDroppableView(_ textDroppableView: UIView & UITextDroppable,
                               proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
            return UITextDropProposal(operation: .cancel)
        }

        func textDroppableView(_ textDroppableView: UIView & UITextDroppable,
                               performDrop drop: UITextDropRequest) {
            // Não faz nada — bloqueia drop
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
