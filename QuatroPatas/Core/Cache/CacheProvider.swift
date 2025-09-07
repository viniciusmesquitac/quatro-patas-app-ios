//
//  CacheProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

@propertyWrapper
struct CacheProvider {
    private let provider: any SACache

    var wrappedValue: any SACache {
        provider
    }

    init(type: StorageType) {
        switch type {
        case .memoryStorage:
            provider = MemoryStorageProvider()
        case .fileManager:
            provider = FileManagerProvider()
        case .userDefaults:
            provider = UserDefaultsProvider()
        }
    }
}
