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
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Formulário de adoção")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            Text("""
                            Para adotar é preciso responder a um questionário que leva em torno de 5 minutos.
                            
                            Lembre-se que adotar um animal requer muita responsabilidade.
                            """)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        Spacer()
                        FormPageView(form: form)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
        }
        .overlay {
             if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .transition(.opacity)
            }
        }
        .onAppear {
            loadForm()
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .top) {
            if !isLoading {
                HStack {
                    Button {
                        navigator.dismiss()
                    } label: {
                        SFIcon.image(.back)
                    }
                    .buttonStyle(FloatingButtonStyle())
                    Spacer()
                }.padding(.horizontal)
            }
        }
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

