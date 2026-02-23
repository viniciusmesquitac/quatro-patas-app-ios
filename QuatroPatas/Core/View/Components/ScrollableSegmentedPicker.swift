//
//  ScrollableSegmentedPicker.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/02/26.
//


import SwiftUI

struct ScrollableSegmentedPicker: View {
    let items: [String]
    @Binding var selected: String

    var height: CGFloat = 40
    var horizontalPadding: CGFloat = 16

    @Namespace private var underlineNS

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        tab(item)
                            .id(item)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, 8)
            }
            .onChange(of: selected) { _, newValue in
                withAnimation(.snappy) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }

    @ViewBuilder
    private func tab(_ item: String) -> some View {
        let isSelected = (item == selected)

        Button {
            withAnimation(.snappy) {
                selected = item
            }
        } label: {
            VStack(spacing: 6) {
                Text(item)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .lineLimit(1)

                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(.primary)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "underline", in: underlineNS)
                    } else {
                        Capsule()
                            .fill(.clear)
                            .frame(height: 3)
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(height: height)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.primary.opacity(0.08) : Color.clear)
        )
    }
}