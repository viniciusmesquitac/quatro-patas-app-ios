//
//  AnimalsSegment.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 04/10/25.
//

import SwiftUI

enum AnimalsSegment: String, CaseIterable, Identifiable {
    case available = "Para adoção"
    case lost = "Perdidos"
    
    var id: String { self.rawValue }
}
