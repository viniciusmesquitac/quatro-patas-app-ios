//
//  NGORowView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct NGORowView: View {
    let ngo: User
    let action: () -> Void
    
    var body: some View {
        HStack {
            if let firstURL = ngo.photo,
               let url = URL(string: firstURL) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(CornerRadius.medium.rawValue)
                    .padding(Padding.medium.rawValue)
            }
            
            VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                Text(ngo.name)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, Padding.medium.rawValue)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.customBackground)
        .cornerRadius(CornerRadius.medium.rawValue)
        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}
