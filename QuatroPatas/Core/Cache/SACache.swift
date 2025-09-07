//
//  SACache.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

protocol SACache {
    func save(_ value: Any, for key: String) throws
    func get(key: String) -> Any?
    func delete(key: String)
}
