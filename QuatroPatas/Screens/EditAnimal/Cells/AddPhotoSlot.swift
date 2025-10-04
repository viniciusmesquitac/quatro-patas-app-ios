//
//  AddPhotoSlot.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/10/25.
//

import SwiftUI

struct AddPhotoSlot: View {
    let action: () -> Void
    private let size = CGSize(width: 155, height: 155)

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadius.medium.rawValue)
                    .strokeBorder(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 2, dash: [6]))
                    .background(Color.gray.opacity(0.1))

                SFIcon.image(.add, color: .gray)
            }
            .frame(width: size.width, height: size.height)
            .aspectRatio(1, contentMode: .fit)
        }
    }
}
