//
//  TagView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI


struct TagItem: Identifiable {
    var id = UUID()
    var tag: AnimalTag
    var icon: Image?
    var action: (() -> Void)? = nil
    var font: Font? = .system(size: 16)
}

struct TagsView: View {
    @State var tags: [TagItem]

    var body: some View {
        FlowLayout(spacing: Spacing.medium.rawValue) {
            ForEach(tags) { item in
                Button(action: { item.action?() }) {
                    HStack(spacing: Spacing.medium.rawValue) {
                        Text(AnimalTag.localized(item.tag))
                        item.icon
                    }
                }
                .buttonStyle(TagButtonStyle())
            }
        }
    }
}
