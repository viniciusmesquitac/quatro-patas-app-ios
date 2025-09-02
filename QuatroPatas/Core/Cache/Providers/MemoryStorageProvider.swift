//
//  MemoryStorageProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import Foundation

final class MemoryStorageProvider: StorageProvider {

    private let cache = NSCache<NSString, AnyObject>()
    
    func save(_ value: Any, for key: String) throws {
        cache.setObject(value as AnyObject, forKey: key as NSString)
    }
    
    func get(key: String) -> Any? {
        return cache.object(forKey: key as NSString)
    }

    func delete(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
}
