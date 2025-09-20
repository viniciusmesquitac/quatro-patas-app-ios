//
//  AnimalsHorizontalSection.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/09/25.
//

import SwiftUI

struct AnimalsHorizontalSection: View {
    /// Título da seção (padrão “Animais”)
    var title: String = "Animais"
    
    /// Lista de itens para mostrar
    let animals: [Animal]
    
    /// Ação ao selecionar um card
    let onSelect: (Animal) -> Void
    
    /// Ação opcional do botão (se nil, não mostra botão)
    var onAcessoryItem: (() -> Void)? = nil
    
    /// Texto opcional do botão (padrão “Ver todos”)
    var acessoryItemTitle: String = "Ver todos"
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            // Cabeçalho com título + botão opcional
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                if let onAcessoryItem = onAcessoryItem {
                    Button(acessoryItemTitle) {
                        onAcessoryItem()
                    }
                    .font(.subheadline)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: Spacing.large.rawValue) {
                    ForEach(animals, id: \.id) { animal in
                        AnimalCardView(animal: animal) {
                            onSelect(animal)
                        }
                        .frame(height: 210)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
