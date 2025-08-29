//
//  LoadingFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct LoadingFormView: View {
    @State private var isLoading = false
    @State private var form: AdoptionForm? = nil

    var body: some View {
        ZStack {
            if let form = form {
                FormPageView(form: form)
                    .transition(.opacity)
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .transition(.opacity)
            }
        }
        .onAppear {
            loadForm()
        }
        .animation(.easeInOut, value: form)
    }

    private func loadForm() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = Bundle.main.url(forResource: "adoption_form", withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let decoded = try JSONDecoder().decode(AdoptionForm.self, from: data)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            isLoading = false
                            form = decoded
                        }
                    }
                } catch {
                    print("Erro no decode:", error)
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
            }
        }
    }
}

