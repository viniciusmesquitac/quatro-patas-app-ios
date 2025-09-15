//
//  AdoptionFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct AdoptionFormView: View {
    @State private var isLoading = false
    @State private var form: AdoptionForm? = nil
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        ZStack {
            if let form = form {
                ScrollView {
                    VStack {
                        Spacer()
                        FormPageView(form: form)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
        }
        .overlay {
             if isLoading {
                 LoadingDotsView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            loadForm()
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Formulário de Adoção")
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
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
            }
        }
    }
}

