//
//  AdoptionFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct AdoptionFormView: View {
    @State private var isLoading = false
    @State private var form: FormTemplate? = nil
    
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        ZStack {
           
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }

    private func loadForm() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = Bundle.main.url(forResource: "adoption_form", withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let decoded = try JSONDecoder().decode(FormTemplate.self, from: data)
                    DispatchQueue.main.async {
                        withAnimation {
                            isLoading = false
                            form = decoded
                            if let form = form {
                                navigator.dismiss()
                                navigator.navigate(to: .formPage(form, FormManager(), 0))
                            }
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

