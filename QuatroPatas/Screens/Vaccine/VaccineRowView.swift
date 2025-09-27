//
//  VaccineRowView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

import SwiftUI

struct VaccineRowView: View {
    
    @State var vaccine: Vaccine?

    var body: some View {
        HStack {
            SFIcon.image(.vaccine)
            Text(vaccine?.name ?? "Nenhum")
        }
    }
}
