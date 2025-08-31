//
//  TextFragment.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 30/08/25.
//

import SwiftUI

struct TextFragment: Identifiable, Hashable {
    let id = UUID()
    let content: String
    var isBold: Bool = false
}
