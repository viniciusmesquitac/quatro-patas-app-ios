//
//  AdoptionFormView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI

struct AdoptionFormView: View {
    @State private var form: AdoptionForm = AdoptionForm(sections: [])
    @State private var answers: [String: String] = [:]
    
    private let service = GoogleFormsService()
    
    var body: some View {
        Form {
            ForEach(form.sections) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.questions) { question in
                        QuestionView(
                            question: question,
                            answer: Binding(
                                get: { answers[question.id] ?? "" },
                                set: { answers[question.id] = $0 }
                            )
                        )
                    }
                }
            }
            
            Section {
                Button(action: {
                    sendForm()
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
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            .listRowInsets(.init())
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Termo de Adoção")
        .onAppear {
            loadForm()
        }
    }
    
    private func loadForm() {
        if let url = Bundle.main.url(forResource: "adoption_form", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoded = try JSONDecoder().decode(AdoptionForm.self, from: data)
                self.form = decoded
            } catch {
                print("Erro no decode:", error)
            }
        }
    }
    
    private func sendForm() {
        service.submitForm(answers: answers) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Enviado com sucesso!")
                case .failure(let error):
                    print("Erro ao enviar: \(error.localizedDescription)")
                }
            }
        }
    }
}

