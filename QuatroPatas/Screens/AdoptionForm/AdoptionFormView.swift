//
//  AdoptionFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct AdoptionFormView: View {

    @EnvironmentObject var navigator: Navigator

    var body: some View {
        Button(action: {
            loadForm()
        }) {
            Text("Enviar Formulário")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(CornerRadius.small.rawValue)
                .padding(.horizontal)
                .padding(.vertical, Padding.medium.rawValue)
        }
    }

    private func loadForm() {
        if let url = Bundle.main.url(forResource: "adoption_form", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoded = try JSONDecoder().decode(AdoptionForm.self, from: data)
                navigator.navigate(to: .formPage(decoded))
            } catch {
                print("Erro no decode:", error)
            }
        }
    }
    

}

