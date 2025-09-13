//
//  FilterProtocol.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 14/08/25.
//


protocol Filter {
    associatedtype Item
    func apply(to items: [Item]) -> [Item]
    func values() -> [String]
    mutating func remove(value: String)
    mutating func removeAll()
}

extension Filter {
    func values() -> [String] {
        return Mirror(reflecting: self).children.compactMap { child in
            if let value = child.value as? String, !value.isEmpty {
                return value
            }
            return nil
        }
    }
}
