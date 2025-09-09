//
//  DateHelper.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 09/09/25.
//

import Foundation

struct DateHelper {
    /// Formata a data opcional para string amigável
    static func formatCreatedAt(_ date: Date?) -> String {
        guard let date = date else { return "Data desconhecida" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short  // ex: 09/09/25
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "pt_BR")
        return "Adicionado em \(formatter.string(from: date))"
    }
}
