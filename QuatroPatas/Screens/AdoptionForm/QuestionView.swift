//
//  QuestionView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/08/25.
//

import SwiftUI
struct QuestionView: View {
    let question: Question
    @Binding var answer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question.title)
                .font(.headline)

            if let subtitle = question.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            switch question.type {
            case .shortAnswer:
                TextField("Digite sua resposta", text: $answer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

            case .longAnswer:
                TextEditor(text: $answer)
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4))
                    )

            case .singleSelection:
                if let options = question.options {
                    Spacer()
                    ForEach(options, id: \.self) { title in
                        option(title: title, selection: $answer)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    func option(title: String, selection: Binding<String>) -> some View {
        Button(action: {
            selection.wrappedValue = title
        }) {
            HStack {
                Image(systemName: selection.wrappedValue == title ? SFIcon.circle_filled.rawValue : SFIcon.circle.rawValue)
                    .foregroundColor(selection.wrappedValue == title ? .primaryColor : .secondary)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(NoneButtonStyle())
    }
}
