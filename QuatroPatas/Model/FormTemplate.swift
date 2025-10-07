//
//  AdoptionForm.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/08/25.
//

import SwiftUI

struct FormTemplate: Decodable, Hashable {
    let url: String
    let sections: [SectionForm]
}
