//
//  Colors.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/07/25.
//

import SwiftUI

extension Color {
    static let primaryColor = Color(UIColor.systemYellow)
    static let primaryColor2 = Color(hex: "#FDF5D0")
    static let secundaryColor = Color(UIColor.systemPurple)
    static let label = Color(UIColor.customLabel)
    static let systemBackground = Color(UIColor.customBackground)
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
