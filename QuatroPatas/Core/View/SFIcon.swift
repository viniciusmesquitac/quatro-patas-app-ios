//
//  SFIcons.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum SFIcon: String {
    case filter = "sliders_horizontal"
    case back = "chevron.left"
    case next = "chevron.right"
    case share = "square.and.arrow.up"
    case checkmark
    case person
    case paw = "pawprint"
    case circle_filled = "largecircle.fill.circle"
    case circle
    case heart
    case heart_filled = "heart.fill"
    case search = "magnifyingglass"
    case close = "xmark.circle"
    case close_filled = "xmark.circle.fill"
    case tip = "lightbulb.circle"
    case more = "ellipsis"
    case success = "checkmark.circle.fill"
    case failure = "xmark.octagon.fill"
    case menu = "square.grid.2x2"
    case add = "plus.circle"
    case decrease =  "minus"
    case arrow_down = "chevron.down"
    case form = "text.page"
    case about = "info.circle"
    case signOut = "rectangle.portrait.and.arrow.forward"
    case favorite = "star"
    case lock = "lock"
    case delete = "trash"
    case medicine = "pills"
    case vaccine = "syringe"
    case weight = "scalemass"
    case annotation = "pencil.and.list.clipboard"
    case report = "megaphone"
    case donate = "gift.fill"
    case addFolder = "folder.badge.plus"
    case location = "location.fill"
    case pin = "map_pin"
    case warning = "exclamationmark.triangle.fill"
    case download = "arrow.down.circle.fill"
    case map = "map.fill"
    case wifi = "wifi.slash"
    case camera =  "camera"
    case eye_open = "eye.slash.fill"
    case eye_close = "eye.fill"
    case tab_adopt = "hand_heart"
    case tab_adopt_filled = "hand_heart_filled"
    case tab_myAnimals = "paw_print"
    case tab_myAnimals_filled = "paw_print_filled"
    case tab_profile = "user"
    case tab_profile_filled = "user_filled"
    case tab_ngo = "house_heart"
    case tab_ngo_filled = "house_heart_filled"
    case notification = "bell.badge"

    static func image(
        _ value: SFIcon,
        scale: Image.Scale = .large,
        color: Color? = nil
    ) -> some View {
        let name = value.rawValue
        let uiImage = UIImage(systemName: name)
        let size = size(for: scale)

        return Group {
            if uiImage != nil {
                Image(systemName: name)
                    .imageScale(scale)
            } else {
                Image(name)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            }
        }
        .foregroundColor(color)
    }
    
    private static func size(for scale: Image.Scale) -> CGFloat {
        switch scale {
        case .small:
            return 16
        case .medium:
            return 18
        case .large:
            return 24
        @unknown default:
            return 24
        }
    }

    static func circle(_ value: SFIcon, scale: Image.Scale = .large, color: Color = Color.primaryColor, size: CGFloat) -> some View {
        let iconSize: CGFloat = size / 1.2
        return SFIcon.image(value, scale: scale, color: .primaryColor)
            .frame(width: iconSize, height: iconSize)
            .background(
                Circle().strokeBorder(Color.primaryColor, lineWidth: 2)
            )
            .frame(width: size, height: size)
    }
}
