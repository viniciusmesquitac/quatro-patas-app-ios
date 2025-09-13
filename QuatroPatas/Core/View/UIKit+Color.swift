//
//  UIKit+Color.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/07/25.
//

import UIKit

extension UIColor {
    
    static var primaryColor: UIColor {
        return UIColor { traitCollection in
            (traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#FFA500") : .systemYellow)!
        }
    }

    static var secondaryColor: UIColor {
        return UIColor { traitCollection in
            (traitCollection.userInterfaceStyle == .dark ? .systemPurple : .systemPurple)
        }
    }

    static var customLabel: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }

    static var customBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .systemGray6 : .white
        }
    }
}


extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
