//
//  AdoptView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 30/09/25.
//

import SwiftUI

struct AdoptView: View {
    
    @State private var filter = AnimalFilter()
    @State var animals: [Animal] = []
    
    var body: some View {
        ScrollView {
            AnimalsAvailableView(filter: $filter, animals: $animals)
        }
        .navigationTitle("Adote")
    }
    
}

