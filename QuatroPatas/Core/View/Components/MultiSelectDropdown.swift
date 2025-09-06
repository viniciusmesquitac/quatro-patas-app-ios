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
        VStack(alignment: .leading, spacing: 4) {
            
            // Label do dropdown
            Button(action: {
                withAnimation(.bouncy) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selections.isEmpty ? title : selections.joined(separator: ", "))
                        .foregroundColor(selections.isEmpty ? .primary : Color.secundaryColor)
                        .font(.system(size: 16, weight: .medium))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(selections.isEmpty ? .secondary : Color.secundaryColor)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(selections.isEmpty ? Color.gray.opacity(0.2) : Color.primaryColor.opacity(0.2))
                .cornerRadius(CornerRadius.medium.rawValue)
            }
            .buttonStyle(FilterButtonStyle())
            
            // Lista de opções
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                if selections.contains(option) {
                                    selections.removeAll { $0 == option }
                                } else {
                                    selections.append(option)
                                }
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(selections.contains(option) ? Color.secundaryColor : .primary)
                                
                                Spacer()
                                
                                if selections.contains(option) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.secundaryColor)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selections.contains(option) ? Color.primaryColor.opacity(0.2) : Color.clear)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(FilterButtonStyle())
                        
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
