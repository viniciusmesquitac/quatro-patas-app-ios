//
//  AnimalsViewV3.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 30/09/25.
//

import SwiftUI

struct AnimalsViewV3: View {
    
    @State private var filter = AnimalFilter()
    @State private var selectedSegment: AnimalsSegment = .available
    @State var animals: [Animal] = []

    var body: some View {
        ScrollView {
            CustomSegmentedPicker(
                selection: $selectedSegment,
                primaryColor: .primaryColor
            )
            .padding()
            
            switch selectedSegment {
            case .available:
                AnimalsAvailableView(filter: $filter, animals: $animals)
            case .lost:
                AnimalsMissingView()
            @unknown default:
                EmptyView()
            }
        }
        .navigationTitle("Animais")
    }
}
