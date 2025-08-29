//
//  AdoptionFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct AdoptionFormView: View {

    @EnvironmentObject var navigator: Navigator
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }.onAppear {
            loadForm()
        }
    }

    private func loadForm() {
        isLoading = true
        if let url = Bundle.main.url(forResource: "adoption_form", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoded = try JSONDecoder().decode(AdoptionForm.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    isLoading = false
                    navigator.navigate(to: .formPage(decoded))
                })
            } catch {
                print("Erro no decode:", error)
            }
        }
    }
    

}

