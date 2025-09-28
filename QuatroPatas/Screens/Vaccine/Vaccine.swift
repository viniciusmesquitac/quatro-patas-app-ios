//
//  Vaccine.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

@preconcurrency import FirebaseFirestore

struct Vaccine: Codable, Identifiable {
    @DocumentID var id: String?
    
    var name: String
    var customName: String?
    var laboratory: String?
    
    var doseNumber: Int?
    var totalDoses: Int?
    
    var date: String
    var nextDate: String?
    
    var sendNotification: Bool?
    var notificationOption: NotificationOption?
}

enum NotificationOption: String, Codable, CaseIterable, Identifiable {
    case onTheDay = "No dia"
    case oneDayBefore = "1 dia antes"
    case oneWeekBefore = "1 semana antes"
    case oneMonthBefore = "1 mês antes"
    
    var id: String { rawValue }
}
