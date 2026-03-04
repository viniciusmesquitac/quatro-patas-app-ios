//
//  LocalNotificationError.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/03/26.
//


import Foundation
import UserNotifications

enum LocalNotificationError: Error, LocalizedError {
    case notAuthorized

    var errorDescription: String? {
        switch self {
        case .notAuthorized: return "Permissão de notificação não concedida."
        }
    }
}
