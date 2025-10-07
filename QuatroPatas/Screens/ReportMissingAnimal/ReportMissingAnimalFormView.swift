//
//  ReportMissingAnimalFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/10/25.
//

import SwiftUI

struct ReportMissingAnimalFormView: View {
    
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
            form = nil
            loadForm()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func loadForm() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = Bundle.main.url(forResource: "missing_animal", withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                do {
                    let decoded = try JSONDecoder().decode(FormTemplate.self, from: data)
                    withAnimation {
                        isLoading = false
                        form = decoded
                        if let form = form {
                            DispatchQueue.main.async {
                                navigator.dismiss()
                                navigator.navigate(to: .formPage(form, FormManager(), 0))
                            }
                        }
                    }
                } catch {
                    isLoading = false
                }
            }
        }
    }
}


