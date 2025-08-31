//
//  Tip.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 29/08/25.
//
import SwiftUI

struct Tip {
    let id = UUID()
    let title: String
    let description: [TextFragment]
    var buttonText: String?
    var buttonAction: (() -> Void)?
}
