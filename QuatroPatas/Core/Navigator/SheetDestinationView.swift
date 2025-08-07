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
        case .filter:
            AnimalFilterView()
        case .share(let items):
            ShareSheet(items: items)
        }
    }
}
