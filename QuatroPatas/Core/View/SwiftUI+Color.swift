//
//  Colors.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/07/25.
//

import SwiftUI

extension Color {
    static let primaryColor = Color(UIColor.primaryColor)
    static let secondaryColor = Color(UIColor.secondaryColor)
    static let customLabel = Color(UIColor.customLabel)
    static let customBackground = Color(UIColor.customBackground)
    static let primaryBackground = Color(UIColor.primaryBackground)
    static let neutralWhite = Color(hex: "#FAFAFA")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
