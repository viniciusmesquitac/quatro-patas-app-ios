//
//  LocalNotificationService.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/03/26.
//

import Foundation
import UserNotifications

final class LocalNotificationService {

    static let shared = LocalNotificationService()
    private init() {}

    func requestAuthorizationIfNeeded() async throws {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return
        case .denied:
            throw LocalNotificationError.notAuthorized
        case .notDetermined:
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if !granted { throw LocalNotificationError.notAuthorized }
        @unknown default:
            throw LocalNotificationError.notAuthorized
        }
    }

    func scheduleVaccineNotifications(
        animalId: String,
        vaccineName: String,
        nextDate: Date,
        options: Set<NotificationOption>
    ) async throws -> [String] {
        try await requestAuthorizationIfNeeded()

        let center = UNUserNotificationCenter.current()

        var baseComponents = Calendar.current.dateComponents([.year, .month, .day], from: nextDate)
        baseComponents.hour = 9
        baseComponents.minute = 0

        let baseDate = Calendar.current.date(from: baseComponents) ?? nextDate

        var ids: [String] = []

        for opt in options {
            let fireDate: Date = {
                switch opt {
                case .onTheDay:
                    return baseDate
                case .oneDayBefore:
                    return Calendar.current.date(byAdding: .day, value: -1, to: baseDate) ?? baseDate
                case .oneWeekBefore:
                    return Calendar.current.date(byAdding: .day, value: -7, to: baseDate) ?? baseDate
                case .oneMonthBefore:
                    return Calendar.current.date(byAdding: .day, value: -30, to: baseDate) ?? baseDate
                }
            }()

            guard fireDate > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = "Vacina do pet"
            content.body = "\(vaccineName) - lembrete de aplicação"
            content.sound = .default

            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

            let id = "vaccine:\(animalId):\(UUID().uuidString):\(opt.rawValue)"
            let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            try await center.add(req)
            ids.append(id)
        }

        return ids
    }

    func cancel(ids: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}
