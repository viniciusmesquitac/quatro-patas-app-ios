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

    var body: some View {
        ScrollView {
            Text(form.sections[formManager.page].title)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            ForEach(form.sections[formManager.page].questions, id: \.id) { question in
                QuestionView(
                    question: question,
                    answer: Binding(
                        get: { formManager.answers[question.id] ?? "" },
                        set: { formManager.answers[question.id] = $0 }
                    )
                ).padding()
            }
            
            Button(action: {
                if form.sections.indices.contains(formManager.page + 1) {
                    formManager.page += 1
                    self.navigator.navigate(to: .formPage(form))
                } else {
                    sendForm()
                }
            }) {
                Text(form.sections.indices.contains(formManager.page + 1) ? "Próximo" : "Enviar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(CornerRadius.small.rawValue)
                    .padding(.horizontal)
                    .padding(.vertical, Padding.medium.rawValue)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
            if formManager.page > 0 {
                formManager.page -= 1
            }
        })
        
    }
    
    private func sendForm() {
        let formUrl = "https://docs.google.com/forms/d/e/1FAIpQLSdGudwF9f1YkSikuGZqY8FOhPgXwgWTNNAHYvgHJgv1DDeZ1A/formResponse"
        requestProvider.post(url: formUrl, parameters: formManager.answers) { result in
            switch result {
            case .success:
                print("Enviado com sucesso ✅")
                formManager.page = 0
                navigator.popToRoot()
            case .failure(let error):
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
}
