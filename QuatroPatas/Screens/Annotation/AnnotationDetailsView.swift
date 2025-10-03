//
//  AnnotationDetailsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/10/25.
//

import SwiftUI

struct AnnotationDetailsView: View {
    var annotation: Annotation
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.primaryColor)
                    Text(formatDate(annotation.date))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Texto principal
                Text(annotation.text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detalhes da Anotação")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
    
    private func formatDate(_ isoDate: String) -> String {
        if let date = ISO8601DateFormatter().date(from: isoDate) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return isoDate
    }
}
