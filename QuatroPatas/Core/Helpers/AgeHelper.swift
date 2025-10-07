//
//  AgeHelper.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 09/09/25.
//

import Foundation

struct AgeHelper {

    static func formatAge(from timestampString: String) -> String {
        guard let timestamp = TimeInterval(timestampString) else { return "Idade desconhecida" }
        let birthDate = Date(timeIntervalSince1970: timestamp)
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: now)
        let years = components.year ?? 0
        let months = components.month ?? 0
        
        switch (years, months) {
        case (0, 0): return "Menos de 1 mês"
        case (0, 1): return "1 mês"
        case (0, let m): return "\(m) meses"
        case (1, 0): return "1 ano"
        case (let y, 0): return "\(y) anos"
        case (1, 1): return "1 ano e 1 mês"
        case (1, let m): return "1 ano e \(m) meses"
        case (let y, 1): return "\(y) anos e 1 mês"
        default: return "\(years) anos e \(months) meses"
        }
    }

    static func toAgeComponents(from timestampString: String) -> (years: Int, months: Int)? {
        guard let timestamp = TimeInterval(timestampString) else { return nil }
        let birthDate = Date(timeIntervalSince1970: timestamp)
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: now)
        return (components.year ?? 0, components.month ?? 0)
    }

    static func calculateAgeTimestamp(years: Int, months: Int) -> String {
        let calendar = Calendar.current
        let now = Date()

        if let date = calendar.date(byAdding: .year, value: -years, to: now),
           let finalDate = calendar.date(byAdding: .month, value: -months, to: date) {
            let timestamp = finalDate.timeIntervalSince1970
            return String(Int(timestamp))
        }
        
        return "0"
    }

    static func calculateAgeMonth(timestamp: String) -> Int? {
        guard let timestamp = TimeInterval(timestamp) else { return nil }
        let date = Date(timeIntervalSince1970: timestamp)
        let meses = Calendar.current.dateComponents([.month], from: date, to: Date()).month ?? 0
        return meses
    }
}
