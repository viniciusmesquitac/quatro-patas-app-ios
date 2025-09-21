//
//  FirestoreProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 31/08/25.
//

import FirebaseFirestore

class FirestoreProvider: ObservableObject {

    private let db = Firestore.firestore()

    func fetch<T: Codable & Sendable>(
        from collection: String,
        query: ((CollectionReference) -> Query)? = nil
    ) async throws -> [T] {
        try await withCheckedThrowingContinuation { continuation in
            let base = db.collection(collection)
            let ref = query?(base) ?? base
            
            ref.getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    do {
                        let items = try snapshot?.documents.compactMap {
                            try $0.data(as: T.self)
                        } ?? []
                        continuation.resume(returning: items)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
       func fetchDocument<T: Codable & Sendable>(
           from collection: String,
           id: String
       ) async throws -> T? {
           try await withCheckedThrowingContinuation { continuation in
               db.collection(collection).document(id).getDocument { snapshot, error in
                   if let error = error {
                       continuation.resume(throwing: error)
                   } else {
                       do {
                           if let snapshot = snapshot, snapshot.exists {
                               let item = try snapshot.data(as: T.self)
                               continuation.resume(returning: item)
                           } else {
                               continuation.resume(returning: nil) // documento não existe
                           }
                       } catch {
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

    func update<T: Codable & Sendable>(_ item: T, in collection: String, withID id: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try db.collection(collection).document(id).setData(from: item, merge: true) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: id)
                    }
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
    
    func delete(from collection: String, id: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            db.collection(collection).document(id).delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
}

