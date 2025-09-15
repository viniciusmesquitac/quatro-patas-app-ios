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
    
    var body: some View {
        ScrollView {
            VStack {
                Text(form.sections[formManager.page].title)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(spacing: 8) {
                    ForEach(form.sections[formManager.page].questions, id: \.id) { question in
                        QuestionView(
                            question: question,
                            answer: Binding(
                                get: { formManager.answers[question.id] ?? "" },
                                set: { formManager.answers[question.id] = $0 }
                            )
                        )
                    }
                }
                Button(action: {
                    formManager.didSubmit = true // marca que o usuário tentou enviar
                    
                    let currentSection = form.sections[formManager.page]
                    
                    // Pega as obrigatórias que não foram respondidas
                    let emptyQuestions = currentSection.questions
                        .filter { (formManager.answers[$0.id] ?? "").isEmpty }
                        .map { $0.id }
                    
                    if emptyQuestions.isEmpty {
                        // limpa erros
                        formManager.errors.removeAll()
                        
                        if form.sections.indices.contains(formManager.page + 1) {
                            formManager.page += 1
                            self.navigator.navigate(to: .formPage(form))
                        } else {
                            sendForm()
                        }
                    } else {
                        // marca erros
                        toast("Campos obrigatórios precisam ser preenchidos!", .error)
                        formManager.errors = Set(emptyQuestions)
                    }
                }) {
                    Text(form.sections.indices.contains(formManager.page + 1) ? "Próximo" : "Enviar")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(.horizontal)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    navigator.dismiss()
                    formManager.page -= 1
                } label: {
                    SFIcon.image(.back)
                }
                .buttonStyle(FloatingButtonStyle())
                Spacer()
            }.padding(.horizontal)
        }
    }
    
    private func sendForm() {
        let formUrl = "https://docs.google.com/forms/d/e/1FAIpQLSdGudwF9f1YkSikuGZqY8FOhPgXwgWTNNAHYvgHJgv1DDeZ1A/formResponse"
        requestProvider.post(url: formUrl, parameters: formManager.answers) { result in
            switch result {
            case .success:
                toast("Enviado com sucesso", .success)
                formManager.page = 0
                formManager.answers = [:]
                navigator.popToRoot()
            case .failure(let error):
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
}
