//
//  ToastAction.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI

struct ToastAction {
    let action: (String, ToastType) -> ()
    
    func callAsFunction(_ message: String, _ type: ToastType) {
        action(message, type)
    }
}

struct ToastEnviromnentKey: EnvironmentKey {
    static let defaultValue: ToastAction = .init { _, _ in }
}

extension EnvironmentValues {
    var toast: ToastAction {
        get { self[ToastEnviromnentKey.self] }
        set { self[ToastEnviromnentKey.self] = newValue }
    }
}
