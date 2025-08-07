//
//  Sheet.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//


enum Sheet: Hashable, Identifiable {
    case filter
    case share(items: [String])

    var id: String {
        String(describing: self)
    }
}
