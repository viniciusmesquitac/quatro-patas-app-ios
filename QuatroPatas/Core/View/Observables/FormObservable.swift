//
//  FormObservable.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/08/25.
//

import SwiftUI

class FormObservable: ObservableObject {
    @Published var page: Int = 0
    @Published var answers: [String: String] = [:]
}
