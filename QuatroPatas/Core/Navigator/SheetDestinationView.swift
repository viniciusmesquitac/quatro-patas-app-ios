//
//  Untitled.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/08/25.
//


import SwiftUI

struct SheetDestinationView: View {
    let sheet: Sheet

    var body: some View {
        switch sheet {
        case .animalFilter(let animals, let filter):
            AnimalFilterView(animals: animals, filter: filter)
        case .share(let items):
            ShareSheet(items: items)
        case .tip(let title, let description):
            TipView(title: title, descripition: description)
        }
    }
}
