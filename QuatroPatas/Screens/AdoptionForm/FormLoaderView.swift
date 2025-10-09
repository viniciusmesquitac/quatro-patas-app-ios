//
//  FormLoaderView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct FormLoaderView: View {
    @State private var form: FormTemplate? = nil
    @EnvironmentObject var navigator: Navigator
    
    let fileName: String

    var body: some View {
        Rectangle()
        .fill(Color.customBackground)
        .ignoresSafeArea(edges: .all)
        .onAppear {
            loadForm()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }

    private func loadForm() {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoded = try JSONDecoder().decode(FormTemplate.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    form = decoded
                    if let form = form {
                        navigator.dismiss()
                        navigator.navigate(to: .formPage(form, FormManager(), 0))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

