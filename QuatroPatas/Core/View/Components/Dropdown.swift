//
//  Dropdown.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI
import SwiftUI

struct Dropdown: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    @State private var isExpanded = false
    
    private let placeholder: String = "Selecione"
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
            
            // Botão principal
            dropdownButton
            
            // Lista de opções
            if isExpanded {
                optionsList
            }
        }
    }
    
    private var dropdownButton: some View {
        Button(action: {
            withAnimation(.bouncy) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(selection.isEmpty ? title : selection)
                    .foregroundColor(selection.isEmpty || selection == placeholder ? .primary : Color.secondaryColor)
                    .font(.system(size: 16, weight: .medium))
                
                Spacer()
                
                SFIcon.image(.arrow_down)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .foregroundColor(selection.isEmpty || selection == placeholder ? .secondary : Color.secondaryColor)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(dropdownBackgroundColor)
            .cornerRadius(CornerRadius.medium.rawValue)
        }
        .buttonStyle(FilterButtonStyle())
    }
    
    private var optionsList: some View {
        VStack(spacing: .zero) {
            ForEach(options, id: \.self) { option in
                optionRow(option)
                if option != options.last {
                    Divider()
                }
            }
        }
        .background(Color.clear)
        .cornerRadius(CornerRadius.medium.rawValue)
        .shadow(radius: 4)
    }
    
    private func optionRow(_ option: String) -> some View {
        Button(action: {
            withAnimation {
                selection = option
                isExpanded = false
            }
        }) {
            HStack {
                Text(option)
                    .foregroundColor(selection == option ? Color.secondaryColor : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(selection == option ? Color.primaryColor.opacity(0.2) : Color.gray.opacity(0.2))
        }
        .buttonStyle(FilterButtonStyle())
    }
    
    private var dropdownBackgroundColor: Color {
        selection.isEmpty || selection == placeholder
        ? Color.gray.opacity(0.2)
        : Color.primaryColor.opacity(0.2)
    }
}
