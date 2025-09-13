//
//  MultiSelectDropdown.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/09/25.
//

import SwiftUI

struct MultiSelectDropdown: View {
    let title: String
    let options: [String]
    @Binding var selections: [String]
    @State private var isExpanded = false
    
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
    
    // MARK: - Subviews
    
    private var dropdownButton: some View {
        Button(action: {
            withAnimation(.bouncy) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(selections.isEmpty ? title : selections.joined(separator: ", "))
                    .foregroundColor(selections.isEmpty ? .primary : Color.secondaryColor)
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
                SFIcon.image(.arrow_down)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .foregroundColor(selections.isEmpty ? .secondary : Color.secondaryColor)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(dropdownBackgroundColor)
            .cornerRadius(CornerRadius.medium.rawValue)
        }
        .buttonStyle(FilterButtonStyle())
    }
    
    private var optionsList: some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                optionRow(option)
                if option != options.last {
                    Divider()
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private func optionRow(_ option: String) -> some View {
        Button(action: {
            withAnimation {
                toggleSelection(option)
            }
        }) {
            HStack {
                Text(option)
                    .foregroundColor(selections.contains(option) ? Color.secondaryColor : .primary)
                
                Spacer()
                
                if selections.contains(option) {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.secondaryColor)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(selections.contains(option) ? Color.primaryColor.opacity(0.2) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(FilterButtonStyle())
    }
    
    // MARK: - Helpers
    
    private var dropdownBackgroundColor: Color {
        selections.isEmpty ? Color.gray.opacity(0.2) : Color.primaryColor.opacity(0.2)
    }
    
    private func toggleSelection(_ option: String) {
        if selections.contains(option) {
            selections.removeAll { $0 == option }
        } else {
            selections.append(option)
        }
    }
}
