//
//  UserDefaultsProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import Foundation

final class UserDefaultsProvider: SACache {
    private let defaults: UserDefaults

    init(suiteName: String? = nil) {
        if let suiteName = suiteName {
            self.defaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            self.defaults = .standard
        }
    }

    func save(_ value: Any, for key: String) throws {
        if let data = value as? Data {
            defaults.set(data, forKey: key)
        } else if let string = value as? String {
            defaults.set(string, forKey: key)
        } else if let number = value as? NSNumber {
            defaults.set(number, forKey: key)
        } else if let bool = value as? Bool {
            defaults.set(bool, forKey: key)
        } else if let url = value as? URL {
            defaults.set(url, forKey: key)
        } else {
            throw NSError(domain: "UserDefaultsProvider",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unsupported type: \(type(of: value))"])
        }
    }

    func get(key: String) -> Any? {
        return defaults.object(forKey: key)
    }

    func delete(key: String) {
        defaults.removeObject(forKey: key)
    }
}
