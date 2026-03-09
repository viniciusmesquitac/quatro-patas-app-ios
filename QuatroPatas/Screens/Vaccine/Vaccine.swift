//
//  Vaccine.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

@preconcurrency import FirebaseFirestore

struct Vaccine: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let customName: String?
    let laboratory: String?
    let doseNumber: Int?
    let totalDoses: Int?
    let date: String
    let nextDate: String?
    let sendNotification: Bool
    let notificationOption: NotificationOption?
    var notificationIds: [String]?
}

enum NotificationOption: String, Codable, CaseIterable, Identifiable {
    case onTheDay = "No dia"
    case oneDayBefore = "1 dia antes"
    case oneWeekBefore = "1 semana antes"
    case oneMonthBefore = "1 mês antes"
    
    var id: String { rawValue }
}
