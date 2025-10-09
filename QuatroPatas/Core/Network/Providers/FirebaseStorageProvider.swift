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

    func uploadFile(
        data: Data,
        path: String,
        contentType: String = "image/jpeg",
        progress: Binding<Double>? = nil
    ) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let storageRef = storage.reference().child(path)
            let metadata = StorageMetadata()
            metadata.contentType = contentType
            
            let uploadTask = storageRef.putData(data, metadata: metadata)
            
            // Observa o progresso do upload
            let progressObserver = uploadTask.observe(.progress) { snapshot in
                guard let fractionCompleted = snapshot.progress?.fractionCompleted else { return }
                DispatchQueue.main.async {
                    progress?.wrappedValue = fractionCompleted
                }
            }
            
            // Observa o sucesso ou erro
            uploadTask.observe(.success) { _ in
                uploadTask.removeObserver(withHandle: progressObserver)
                storageRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let url = url {
                        continuation.resume(returning: url)
                    }
                }
            }
            
            uploadTask.observe(.failure) { snapshot in
                uploadTask.removeObserver(withHandle: progressObserver)
                let error = snapshot.error ?? NSError(domain: "UploadError", code: -1, userInfo: nil)
                continuation.resume(throwing: error)
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
