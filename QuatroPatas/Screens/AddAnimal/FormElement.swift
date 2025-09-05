//
//  FormElement.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/09/25.
//

import SwiftUI

enum FormElement: Identifiable {
    case textField(title: String, placeholder: String, binding: Binding<String>, keyboard: UIKeyboardType = .default)
    case textEditor(title: String, binding: Binding<String>)
    case selectable(title: String, options: [String], binding: Binding<String>)
    case dropdown(title: String, options: [String], binding: Binding<String>)
    
    var id: String {
        switch self {
        case .textField(let title, _, _, _): return title
        case .textEditor(let title, _): return title
        case .selectable(let title, _, _): return title
        case .dropdown(let title, _, _): return title
        }
    }
}
