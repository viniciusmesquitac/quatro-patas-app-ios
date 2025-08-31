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
    var action: () -> Void
}

struct TagsView: View {
    @State var tags: [TagItem]

    var body: some View {
        FlowLayout(spacing: Spacing.medium.rawValue) {
            ForEach(tags) { item in
                Button(action: { item.action() }) {
                    HStack(spacing: Spacing.medium.rawValue) {
                        Text(item.tag.rawValue)
                            .foregroundColor(.primary)
                        item.icon
                    }
                    .padding(.vertical, Padding.medium.rawValue)
                    .padding(.horizontal, Padding.large.rawValue)
                    .background(Color.primaryColor.opacity(0.2))
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
