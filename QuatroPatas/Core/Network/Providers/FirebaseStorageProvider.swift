//
//  FirebaseStorageProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/09/25.
//


import Foundation
import FirebaseStorage
import SwiftUI

class FirebaseStorageProvider: ObservableObject {

    private let storage = Storage.storage()

    /// Faz upload de um arquivo (ex: imagem) para o Storage e retorna a URL de download
    func uploadFile(data: Data, path: String, contentType: String = "image/jpeg") async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let storageRef = storage.reference().child(path)
            let metadata = StorageMetadata()
            metadata.contentType = contentType
            
            storageRef.putData(data, metadata: metadata) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let url = url {
                            continuation.resume(returning: url)
                        }
                    }
                }
            }
        }
    }
}
