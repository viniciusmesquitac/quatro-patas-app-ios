//
//  VaccineRowView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

import SwiftUI

struct VaccineRowView: View {
    
    var vaccine: Vaccine

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.medium.rawValue) {
            SFIcon.circle(.vaccine, size: 64)
            
            VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
                Text(vaccine.name)
                    .font(.headline)
                
                if let brand = vaccine.laboratory {
                    Text("Marca: \(brand)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("Aplicação: \(formatDate(vaccine.date))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if let laboratory = vaccine.laboratory {
                    Text("Laboratório: \(laboratory)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let nextDate = vaccine.nextDate {
                    Text("Proxima aplicação: \(formatDate(nextDate))")
                        .font(.caption)
                        .padding(Padding.small.rawValue)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(CornerRadius.medium.rawValue)
                }
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
