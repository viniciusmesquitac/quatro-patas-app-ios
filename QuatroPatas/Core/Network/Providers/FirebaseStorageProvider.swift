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
    
    func deleteFile(path: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let storageRef = storage.reference().child(path)
            
            storageRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }

    func deleteFolder(path: String) async throws {
        let folderRef = storage.reference().child(path)
        
        // lista todos os arquivos dentro do prefixo
        let result = try await folderRef.listAll()
        
        for item in result.items {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                item.delete { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }
        }
    }
}
