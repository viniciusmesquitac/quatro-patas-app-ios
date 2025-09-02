//
//  FileManagerProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 02/09/25.
//

import Foundation

final class FileManagerProvider: StorageProvider {
    private let fileManager = FileManager.default
    private let directory: URL

    init(folderName: String = "Cache") {
        directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(folderName)

        if !fileManager.fileExists(atPath: directory.path) {
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }

    func save(_ value: Any, for key: String) throws {
        let path = directory.appendingPathComponent(key)

        if let data = value as? Data {
            try data.write(to: path)
        } else if let string = value as? String {
            try string.data(using: .utf8)?.write(to: path)
        } else {
            throw NSError(domain: "FileManagerProvider",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unsupported type: \(type(of: value))"])
        }
    }

    func get(key: String) -> Any? {
        let path = directory.appendingPathComponent(key)
        guard fileManager.fileExists(atPath: path.path) else { return nil }
        return try? Data(contentsOf: path)
    }

    func delete(key: String) {
        let path = directory.appendingPathComponent(key)
        try? fileManager.removeItem(at: path)
    }
}
