//
//  Sheet.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

enum Sheet: Identifiable {
    case animalFilter([Animal], Binding<AnimalFilter>)
    case share(items: [Any])
    case tip(Tip)
    case logout

    var id: String {
        String(describing: self)
    }
}
