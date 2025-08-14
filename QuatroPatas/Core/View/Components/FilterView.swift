//
//  FilterView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/08/25.
//

import SwiftUI

struct FilterView<AnyFilter: Filter>: View {
    
   @Binding var filter: AnyFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.medium.rawValue) {
                ForEach(filter.values(), id: \.self) { item in
                    HStack(spacing: Spacing.medium.rawValue) {
                        Text(item)
                            .foregroundColor(.primaryColor)
                        
                        Button(action: {
                            filter.remove(value: item)
                        }) {
                            SFIcons.image(.close, scale: .small)
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .padding(.vertical, Padding.medium.rawValue)
                    .padding(.horizontal, Padding.large.rawValue)
                    .background(Color.secundaryColor)
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
