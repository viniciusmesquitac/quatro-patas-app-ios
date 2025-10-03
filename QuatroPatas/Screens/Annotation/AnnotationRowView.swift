//
//  AnnotationRowView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/10/25.
//

import SwiftUI

struct AnnotationRowView: View {
    
    var annotation: Annotation

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.medium.rawValue) {
            SFIcon.circle(.annotation, size: 64)
            
            VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                Text("Nova nota")
                    .font(.headline)
                
                
                Text("Data: \(formatDate(annotation.date))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            
            }
            Spacer()
        }
        .padding(.vertical, Padding.medium.rawValue)
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
