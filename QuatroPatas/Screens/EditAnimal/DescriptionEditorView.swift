//
//  DescriptionEditorView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/09/25.
//

import SwiftUI

struct DescriptionEditorView: View {

    @Binding var text: String

    @EnvironmentObject var navigator: Navigator
    
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .font(.body)
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                .focused($isFocused)
        }
        .navigationTitle("Descrição")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarItem(label: "Salvar", placement: .topBarTrailing, action: {
            navigator.dismiss()
        })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
        .animation(.easeInOut, value: text)
    }
}
