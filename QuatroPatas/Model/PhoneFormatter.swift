//
//  PhoneFormatter.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 29/08/25.
//

import Foundation

struct PhoneFormatter {
    static func applyMask(_ text: String) -> String {
        // só mantém números
        let digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        let count = digits.count
        
        if count == 0 { return "" }
        
        // DDD
        result += "("
        result += digits.prefix(2)
        
        if count >= 2 {
            result += ") "
        }
        
        let start = digits.index(digits.startIndex, offsetBy: min(2, count))
        let remaining = String(digits[start...])
        
        if count <= 6 {
            // até 6 dígitos → (11) 9876
            result += remaining
        } else if count <= 10 {
            // fixo: (11) 9876-5432
            let prefix = remaining.prefix(4)
            let suffix = remaining.suffix(from: remaining.index(remaining.startIndex, offsetBy: 4))
            result += prefix + "-" + suffix
        } else {
            // celular: (11) 98765-4321
            let prefix = remaining.prefix(5)
            let suffix = remaining.suffix(from: remaining.index(remaining.startIndex, offsetBy: 5))
            result += prefix + "-" + suffix
        }
        
        return result
    }
}
