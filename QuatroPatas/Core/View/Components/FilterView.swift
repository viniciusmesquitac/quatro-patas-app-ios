//
//  FilterView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/08/25.
//

import SwiftUI

struct FilterView<AnyFilter: Filter>: View {
    
   @Binding var filter: AnyFilter

    var values: [String] {
        filter.values()
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.medium.rawValue) {
                ForEach(values, id: \.self) { item in
                    HStack(spacing: Spacing.medium.rawValue) {
                        Text(item)
                            .foregroundColor(.customBackground)
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                filter.remove(value: item)
                            }
                        }) {
                            SFIcon.image(.close, scale: .medium, color: .customBackground)
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .padding(.vertical, Padding.medium.rawValue)
                    .padding(.horizontal, Padding.large.rawValue)
                    .background(Color.primaryColor)
                    .clipShape(Capsule())
                }
            }
            .padding(.leading, Padding.large.rawValue)
        }
    }
}
#Preview {
    @Previewable @State var filter = AnimalFilter(animalType: "Cachorro", gender: "Macho", breed: nil, size: nil)
    FilterView(filter: $filter)
}
