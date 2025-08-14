//
//  FilterProtocol.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/08/25.
//


protocol Filter {
    associatedtype Item
    func apply(to items: [Item]) -> [Item]
}
