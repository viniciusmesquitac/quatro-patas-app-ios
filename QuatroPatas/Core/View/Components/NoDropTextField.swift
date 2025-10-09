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
        textField.borderStyle = .roundedRect

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

        // Impede drop de qualquer tipo
        func textDroppableView(_ textDroppableView: UIView & UITextDroppable, 
                               proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
            return UITextDropProposal(operation: .cancel)
        }

        func textDroppableView(_ textDroppableView: UIView & UITextDroppable, 
                               performDrop drop: UITextDropRequest) {
            // não faz nada
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
