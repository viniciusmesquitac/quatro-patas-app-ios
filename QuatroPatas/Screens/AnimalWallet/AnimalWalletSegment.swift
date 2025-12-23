//
//  AnimalWalletSegment.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/12/25.
//


enum AnimalWalletSegment: String, CaseIterable, Identifiable {
    case sheet = "Ficha"
    case health = "Saúde"

    var id: String { self.rawValue }
}