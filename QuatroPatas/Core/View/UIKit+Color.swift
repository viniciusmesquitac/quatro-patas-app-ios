//
//  UIKit+Color.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/07/25.
//

import UIKit

extension UIColor {
    static var customLabel: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }

    static var customBackground: UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
    }
}
