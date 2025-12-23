//
//  AdoptionTip.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/12/25.
//

import Foundation

struct AdoptionTip: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var subtitle: String
    var description: String
}
