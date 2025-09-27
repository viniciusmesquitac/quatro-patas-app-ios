//
//  Vaccine.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

import SwiftUI

struct Vaccine: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var brand: String?
    var dosage: String?
    var date: String
    var isRecorrent: Bool?
}
