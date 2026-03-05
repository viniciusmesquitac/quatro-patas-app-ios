//
//  DropdownView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI

struct DropdownView: View {
    
    enum SelectionMode {
        case single(binding: Binding<String>)
        case multiple(binding: Binding<[String]>)
    }
    let options: [String]
    let mode: SelectionMode
    
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
    
    // MARK: - Subviews
    
    private var dropdownButton: some View {
        Button(action: {
            withAnimation(.bouncy) {
                isExpanded.toggle()
            }
        }) {
            HStack {
                Text(displayedText)
                    .foregroundColor(displayedText == placeholder ? .secondary : .primary)
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
                SFIcon.image(.arrow_down, color: displayedText == placeholder ? .secondary : .primary)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
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
        .background(Color.gray.opacity(0.1))
        .cornerRadius(CornerRadius.medium.rawValue)
    }
    
    private func optionRow(_ option: String) -> some View {
        Button(action: {
            withAnimation {
                handleSelection(option)
            }
        }) {
            HStack {
                Text(option)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if case .multiple = mode, isSelected(option) {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.primaryColor)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected(option) ? Color.primaryColor.opacity(0.2) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(FilterButtonStyle())
    }
    
    // MARK: - Helpers
    
    private var displayedText: String {
        switch mode {
        case .single(let binding):
            return binding.wrappedValue.isEmpty ? placeholder : binding.wrappedValue
        case .multiple(let binding):
            return binding.wrappedValue.isEmpty ? placeholder : binding.wrappedValue.joined(separator: ", ")
        }
    }
    
    private var dropdownBackgroundColor: Color {
        displayedText == placeholder
        ? Color.gray.opacity(0.1)
        : Color.primaryColor.opacity(0.2)
    }
    
    private func isSelected(_ option: String) -> Bool {
        switch mode {
        case .single(let binding):
            return binding.wrappedValue == option
        case .multiple(let binding):
            return binding.wrappedValue.contains(option)
        }
    }
    
    private func handleSelection(_ option: String) {
        switch mode {
        case .single(let binding):
            binding.wrappedValue = option
            isExpanded = false
        case .multiple(let binding):
            if binding.wrappedValue.contains(option) {
                binding.wrappedValue.removeAll { $0 == option }
            } else {
                binding.wrappedValue.append(option)
            }
        }
    }
}
