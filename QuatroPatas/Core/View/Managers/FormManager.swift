//
//  FormManager.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/08/25.
//

import SwiftUI

class FormManager: ObservableObject {
    @Published var page: Int = 0
    @Published var answers: [String: String] = [:]
}
