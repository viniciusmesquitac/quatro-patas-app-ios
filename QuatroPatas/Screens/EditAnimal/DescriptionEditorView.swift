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

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .ignoresSafeArea(edges: .all)
        }
        .navigationTitle("Descrição")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarItem(label: "Salvar", placement: .topBarTrailing, action: {
            navigator.dismiss()
        })
    }
}
