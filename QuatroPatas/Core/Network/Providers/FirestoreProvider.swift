//
//  FirestoreProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/08/25.
//

import FirebaseFirestore

class FirestoreProvider: ObservableObject {

    private let db = Firestore.firestore()

    func fetch<T: Codable & Sendable>(from collection: String) async throws -> [T] {
        try await withCheckedThrowingContinuation { continuation in
            db.collection(collection).getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    do {
                        let items = try snapshot?.documents.compactMap {
                            try $0.data(as: T.self)
                        } ?? []
                        continuation.resume(returning: items)
                    } catch {
                        print("❌ Erro decodificando Animal:", error)
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    func add<T: Codable>(_ item: T, to collection: String, withID id: String? = nil) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            do {
                if let id = id {
                    try db.collection(collection).document(id).setData(from: item) { error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: id)
                        }
                    }
                } else {
                    let ref = try db.collection(collection).addDocument(from: item)
                    continuation.resume(returning: ref.documentID)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func listen<T: Codable>(
        from collection: String,
        onUpdate: @escaping (Result<[T], Error>) -> Void
    ) -> ListenerRegistration? {
        db.collection(collection).addSnapshotListener { snapshot, error in
            if let error = error {
                onUpdate(.failure(error))
            } else {
                do {
                    let items = try snapshot?.documents.compactMap {
                        try $0.data(as: T.self)
                    } ?? []
                    onUpdate(.success(items))
                } catch {
                    onUpdate(.failure(error))
                }
            }
        }
    }
}
