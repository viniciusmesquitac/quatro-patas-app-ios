//
//  FormPageView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/08/25.
//

import SwiftUI

struct FormPageView: View {
    
    @State var form: FormTemplate
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var requestProvider: RequestProvider
    @Environment(\.toast) var toast
    @StateObject var formManager: FormManager
    
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
                        SFIcon.image(.next, color: .customBackground)
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
        .environmentObject(formManager)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(form.sections[currentPage].title)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
    }
    
    private func sendForm() {
        requestProvider.post(url: form.url, parameters: formManager.answers) { result in
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
        formManager.didSubmit = true
        
        let currentSection = form.sections[currentPage]
        
        let invalidQuestions = currentSection.questions.filter { question in
            let answer = formManager.answers[question.id] ?? ""
            
            switch question.type {
            case .email:
                return !Validator.isValidEmail(answer)
            case .age:
                return !Validator.isValidAge(answer)
            case .phone:
                return !Validator.isValidPhone(answer)
            default:
                return answer.isEmpty
            }
        }.map { $0.id }
        
        if invalidQuestions.isEmpty {
            // limpa erros
            formManager.errors.removeAll()
            
            if form.sections.indices.contains(currentPage + 1) {
                self.navigator.navigate(to: .formPage(form, formManager, currentPage + 1))
            } else {
                sendForm()
            }
        } else {
            toast("Verifique os campos obrigatórios ou inválidos!", .error)
            formManager.errors = Set(invalidQuestions)
        }
    }
}
