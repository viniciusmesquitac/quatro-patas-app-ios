//
//  Dropdown.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI

struct Dropdown: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            // Label do dropdown
            Button(action: {
                withAnimation(.bouncy) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selection.isEmpty ? title : selection)
                        .foregroundColor(selection.isEmpty || selection == "Selecione" ? .primary : Color.secundaryColor)
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(selection.isEmpty || selection == "Selecione" ? .secondary : Color.secundaryColor)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(selection.isEmpty || selection == "Selecione" ? Color.gray.opacity(0.2): Color.primaryColor.opacity(0.2))
                .cornerRadius(CornerRadius.medium.rawValue)
            }
            .buttonStyle(FilterButtonStyle()) // tira highlight default do botão
            
            // Lista de opções
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                selection = option
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(selection == option ? Color.secundaryColor : .primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(selection == option ? Color.primaryColor.opacity(0.2) : Color.clear)
                            .contentShape(Rectangle()) // <-- toda a área vira clicável
                        }
                        .buttonStyle(FilterButtonStyle()) // mantém o estilo liso
                        
                        if option != options.last {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
            }
        }
    }
}
