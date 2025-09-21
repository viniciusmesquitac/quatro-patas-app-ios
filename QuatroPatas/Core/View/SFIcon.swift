//
//  SFIcons.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum SFIcon: String {
    case filter = "line.3.horizontal.decrease.circle"
    case back = "chevron.left"
    case next = "chevron.right"
    case share = "square.and.arrow.up"
    case checkmark = "checkmark"
    case person = "person.circle.fill"
    case paw = "pawprint"
    case circle_filled = "largecircle.fill.circle"
    case circle = "circle"
    case heart = "heart"
    case heart_filled = "heart.fill"
    case search = "magnifyingglass"
    case close = "xmark.circle"
    case tip = "lightbulb.circle"
    case more = "ellipsis"
    case success = "checkmark.circle.fill"
    case failure = "xmark.octagon.fill"
    case menu = "square.grid.2x2"
    case add = "plus.circle"
    case arrow_down = "chevron.down"
    case form = "text.page"
    case about = "info.circle"
    case signOut = "rectangle.portrait.and.arrow.forward"
    case favorite = "star"
    case lock = "lock"
    case delete = "trash"

    static func image(_ value: SFIcon, scale: Image.Scale = .large, color: Color = Color.primaryColor) -> some View {
        Image(systemName: value.rawValue)
            .foregroundColor(color)
            .imageScale(scale)
    }
}
