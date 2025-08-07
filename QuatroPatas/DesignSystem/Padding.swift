//
//  Padding.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import UIKit
import SwiftUI

enum Padding: CGFloat {
    case none = 0
    case small = 4
    case medium = 8
    case large = 16
    case xLarge = 24
    case xxLarge = 32

    static func left(_ value: Padding) -> EdgeInsets {
        .init(top: .zero, leading: value.rawValue, bottom: .zero, trailing: .zero)
    }

    static func right(_ value: Padding) -> EdgeInsets {
        .init(top: .zero, leading: .zero, bottom: .zero, trailing: value.rawValue)
    }

    static func top(_ value: Padding) -> EdgeInsets {
        .init(top: value.rawValue, leading: .zero, bottom: .zero, trailing: .zero)
    }

    static func bottom(_ value: Padding) -> EdgeInsets {
        .init(top: .zero, leading: .zero, bottom: value.rawValue, trailing: .zero)
    }

    static func leftAndRight(_ value: Padding) -> EdgeInsets {
        .init(top: .zero, leading: value.rawValue, bottom: .zero, trailing: value.rawValue)
    }

}
