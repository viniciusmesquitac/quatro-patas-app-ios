//
//  HappyEndingCard.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/12/25.
//

import SwiftUI

struct HappyEndingCard: View {

    let happyEndings: [HappyEnding]
    @State private var selectedIndex = 0
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        VStack(spacing: 12) {
            TabView(selection: $selectedIndex) {
                ForEach(happyEndings.indices, id: \.self) { index in
                    if let url = URL(string: happyEndings[index].imageUrl) {
                        CachedAsyncImage(url: url)
                            .tag(index)
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: UIScreen.main.bounds.width - 48,
                                height: 250
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .clipped()
                            .onTapGesture {
                                navigator.navigate(
                                    to: .happyEndingDetails(
                                        imageUrl: happyEndings[index].imageUrl
                                    )
                                )
                            }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 250)

            indicators
        }
    }

    private var indicators: some View {
        HStack(spacing: 8) {
            ForEach(happyEndings.indices, id: \.self) { index in
                Circle()
                    .fill(index == selectedIndex
                          ? Color.primary
                          : Color.secondary.opacity(0.35))
                    .frame(
                        width: index == selectedIndex ? 9 : 7,
                        height: index == selectedIndex ? 9 : 7
                    )
                    .animation(.easeInOut(duration: 0.2), value: selectedIndex)
            }
        }
    }
}
