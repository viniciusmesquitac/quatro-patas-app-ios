//
//  TabItem.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/08/25.
//

import SwiftUI

struct TabItem<Content: View>: View {
    let content: Content
    let tab: AppTab

    @EnvironmentObject var navigator: Navigator

    init(
        label: AppTab,
        @ViewBuilder content: () -> Content
    ) {
        self.tab = label
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $navigator.path) {
            content.applyRoute()
        }
        .tag(tab)
        .tabItem {
            Label {
                Text(tab.rawValue)
            } icon: {
                SFIcon.image(navigator.selectedTab == tab ? tab.selectedIcon : tab.icon)
            }
        }
    }
}
