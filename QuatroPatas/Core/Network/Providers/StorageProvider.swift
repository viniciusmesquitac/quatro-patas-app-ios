//
//  StorageProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/09/25.
//

import Foundation
import Supabase

@MainActor
class StorageProvider: ObservableObject {
    private let storage: StorageFileApi

    init(bucketName: String = "quatro-patas-bucket") {
        self.storage = SupabaseManager.shared.client.storage.from(bucketName)
    }

    func uploadFile(data: Data, path: String, contentType: String = "image/jpeg") async throws -> URL {
        try await storage.upload(path, data: data)
        let publicURL = try storage.getPublicURL(path: path)
        return publicURL
    }

    func deleteFile(path: String) async throws {
        try await storage.remove(paths: [path])
    }

    func deleteFolder(path: String) async throws {
        let files = try await storage.list(path: path)
        for file in files {
            try await storage.remove(paths: [file.name])
        }
    }
}
