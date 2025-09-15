//
//  FormManager.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/08/25.
//

import SwiftUI

class FormManager: ObservableObject {
    @Published var answers: [String: String] = [:]
    @Published var errors: Set<String> = []
    @Published var didSubmit: Bool = false
}
