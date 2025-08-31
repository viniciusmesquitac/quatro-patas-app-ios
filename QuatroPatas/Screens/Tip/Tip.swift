//
//  Tip.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 29/08/25.
//
import SwiftUI

struct Tip: Hashable {
    let id = UUID()
    let title: String
    let description: [TextFragment]
    var buttonText: String?
    var buttonAction: (() -> Void)?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(buttonText)
    }

    static func == (lhs: Tip, rhs: Tip) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.buttonText == rhs.buttonText
    }
}
