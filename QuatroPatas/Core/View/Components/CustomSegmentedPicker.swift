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

    init(selection: Binding<T>, primaryColor: Color) {
        self._selection = selection
        self.primaryColor = primaryColor

        let appearance = UISegmentedControl.appearance()
        appearance.selectedSegmentTintColor = UIColor(primaryColor)

        appearance.setTitleTextAttributes([
            .foregroundColor : UIColor.customLabel,
            .font : UIFont.systemFont(ofSize: 16, weight: .semibold)
        ], for: .normal)

        appearance.setTitleTextAttributes([
            .foregroundColor : UIColor.systemBackground,
            .font : UIFont.systemFont(ofSize: 16, weight: .semibold)
        ], for: .selected)
    }

    var body: some View {
        Picker("Segment", selection: $selection) {
            ForEach(Array(T.allCases), id: \.self) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .tint(primaryColor)
        .scaleEffect(y: 1.12)
        .padding(.vertical, Padding.small.rawValue)
    }
}
