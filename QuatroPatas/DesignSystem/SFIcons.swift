//
//  SFIcons.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum SFIcons: String {
    case filter = "line.3.horizontal.decrease.circle"
    case back = "chevron.left"
    case share = "square.and.arrow.up"
    case checkmark = "checkmark"
    case person = "person.circle.fill"
    case paw = "pawprint"
    case circle_filled = "largecircle.fill.circle"
    case circle = "circle"

    static func image(_ value: SFIcons, scale: Image.Scale = .large, color: Color = .accentColor) -> some View {
        Image(systemName: value.rawValue)
            .resizable()
            .foregroundColor(color)
            .imageScale(scale)
    }
}
