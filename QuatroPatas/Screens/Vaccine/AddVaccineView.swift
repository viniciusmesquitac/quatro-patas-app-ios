//
//  AddVaccineView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

import SwiftUI

struct AddVaccineView: View {

    @EnvironmentObject var navigator: Navigator

    var animalId: String
    var userId: String

    var vaccinePath: String {
        return "users/\(userId)/animals/\(animalId)/vaccines"
    }

    var body: some View {
        ScrollView {
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Adicionar")
        .toolbar(.hidden, for: .tabBar)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
    }
    
}
