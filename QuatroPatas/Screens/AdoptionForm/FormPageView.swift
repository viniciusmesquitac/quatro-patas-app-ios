//
//  FormPageView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/08/25.
//

import SwiftUI

struct FormPageView: View {
    
    @State var form: AdoptionForm
    
    @EnvironmentObject var formManager: FormManager
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var requestProvider: RequestProvider
    @Environment(\.toast) var toast
    
    var currentPage: Int
    
    private var progressValue: Double {
        let total = Double(form.sections.count)
        let current = Double(currentPage + 1)
        return current / total
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Barra de progresso no topo
                ProgressView(value: progressValue, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.primaryColor))
                    .frame(height: 4)
                    .padding(.bottom, Padding.medium.rawValue)
        
                VStack(spacing: Spacing.medium.rawValue) {
                    ForEach(form.sections[currentPage].questions, id: \.id) { question in
                        QuestionView(
                            question: question,
                            answer: Binding(
                                get: { formManager.answers[question.id] ?? "" },
                                set: { formManager.answers[question.id] = $0 }
                            )
                        )
                    }
                }
            }.padding(.horizontal, Padding.large.rawValue)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                if form.sections.indices.contains(currentPage + 1) {
                    Spacer()
                    Button(action: {
                        didPressButton()
                    }) {
                        SFIcon.image(.next, color: .neutralWhite)
                    }
                    .padding(.horizontal, Padding.large.rawValue)
                    .padding(.vertical, Padding.medium.rawValue)
                    .buttonStyle(CircleButtonStyle())
                } else {
                    Button(action: {
                        didPressButton()
                    }) {
                        Text("Enviar")
                    }
                    .padding(.horizontal, Padding.large.rawValue)
                    .padding(.vertical, Padding.medium.rawValue)
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(form.sections[currentPage].title)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
    }
    
    private func sendForm() {
        let formUrl = "https://docs.google.com/forms/d/e/1FAIpQLSdGudwF9f1YkSikuGZqY8FOhPgXwgWTNNAHYvgHJgv1DDeZ1A/formResponse"
        requestProvider.post(url: formUrl, parameters: formManager.answers) { result in
            switch result {
            case .success:
                toast("Enviado com sucesso", .success)
                formManager.answers = [:]
                navigator.popToRoot()
            case .failure(let error):
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
    
    private func didPressButton() {
        formManager.didSubmit = true // marca que o usuário tentou enviar
        
        let currentSection = form.sections[currentPage]
        
        // Pega as obrigatórias que não foram respondidas
        let emptyQuestions = currentSection.questions
            .filter { (formManager.answers[$0.id] ?? "").isEmpty }
            .map { $0.id }
        
        if emptyQuestions.isEmpty {
            // limpa erros
            formManager.errors.removeAll()
            
            if form.sections.indices.contains(currentPage + 1) {
                self.navigator.navigate(to: .formPage(form, currentPage + 1))
            } else {
                sendForm()
            }
        } else {
            // marca erros
            toast("Campos obrigatórios precisam ser preenchidos!", .error)
            formManager.errors = Set(emptyQuestions)
        }
    }
}
