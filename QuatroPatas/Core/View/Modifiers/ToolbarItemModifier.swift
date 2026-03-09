//
//  BackButtonModifier.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/07/25.
//

import SwiftUI
struct ToolbarItemModifier: ViewModifier {
    @EnvironmentObject var navigator: Navigator

    var label: String?
    var icon: SFIcon?
    var iconPosition: ToolbarIconPosition = .leading
    var color: Color
    var placement: ToolbarItemPlacement
    var action: (() -> Void)

    @Binding var disabled: Bool

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: placement) {
                    Button(action: action) {
                        toolbarContent
                    }
                    .tint(color)
                    .foregroundStyle(color)
                    .disabled(disabled)
                }
            }
    }

    @ViewBuilder
    private var toolbarContent: some View {
        if let label, !label.isEmpty, let icon {
            HStack(spacing: 6) {
                if iconPosition == .leading {
                    Image(systemName: icon.rawValue)
                }

                Text(label)

                if iconPosition == .trailing {
                    Image(systemName: icon.rawValue)
                }
            }
            .font(.body.weight(.semibold))
            .lineLimit(1)

        } else if let label, !label.isEmpty {
            Text(label)

        } else if let icon {
            Image(systemName: icon.rawValue)

        } else {
            EmptyView()
        }
    }
}

extension View {
    func toolbarItem(
        label: String? = nil,
        icon: SFIcon? = nil,
        iconPosition: ToolbarIconPosition = .leading,
        color: Color = .primaryColor,
        disabled: Binding<Bool> = .constant(false),
        placement: ToolbarItemPlacement = .automatic,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(
            ToolbarItemModifier(
                label: label,
                icon: icon,
                iconPosition: iconPosition,
                color: color,
                placement: placement,
                action: action,
                disabled: disabled
            )
        )
    }
}

enum ToolbarIconPosition {
    case leading
    case trailing
}
