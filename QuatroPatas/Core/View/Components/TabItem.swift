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
    let icon: SFIcon

    @EnvironmentObject var navigator: Navigator

    init(label: AppTab, icon: SFIcon, @ViewBuilder content: () -> Content) {
        self.tab = label
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $navigator.path) {
            content.applyRoute()
        }
        .tag(tab)
        .tabItem {
            Label(AppTab.localized(tab), systemImage: icon.rawValue)
        }
    }
}
