//
//  CustomSegmentedPicker.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 30/09/25.
//

import SwiftUI
import UIKit

struct CustomSegmentedPicker<T: Hashable & CaseIterable & RawRepresentable>: View where T.RawValue == String {
    @Binding var selection: T
    var primaryColor: Color
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(T.allCases), id: \.self) { option in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.65, blendDuration: 0.2)) {
                        selection = option
                    }
                } label: {
                    Text(option.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selection == option ? .customBackground : .primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .contentShape(Rectangle())
                        .background(
                            ZStack {
                                if selection == option {
                                    RoundedRectangle(cornerRadius: CornerRadius.large.rawValue)
                                        .fill(primaryColor)
                                        .matchedGeometryEffect(id: "segmentBackground", in: animation)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large.rawValue))
    }
}
