//
//  Medication.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/10/25.
//

@preconcurrency import FirebaseFirestore

struct Medication: Codable, Identifiable {
    @DocumentID var id: String?
    
    var name: String
    var laboratory: String?
    
    var doseNumber: Int?
    var totalDoses: Int?
    
    var date: String
    var nextDate: String?
    
    var sendNotification: Bool?
    var notificationOption: NotificationOption?
}
