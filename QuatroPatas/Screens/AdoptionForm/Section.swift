//
//  Section.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct SectionForm: Decodable, Identifiable {
    var id: Int
    let title: String
    let questions: [Question]
}
