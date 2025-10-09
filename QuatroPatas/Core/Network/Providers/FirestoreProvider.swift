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
                            continuation.resume(returning: nil)
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
            Task {
                do {
                    let collectionRef = db.collection(collection)
                    var data = try Firestore.Encoder().encode(item)

                    if data["position"] == nil {
                        let snapshot = try await collectionRef.getDocuments()
                        data["position"] = snapshot.documents.count
                    }

                    if let id = id {
                        collectionRef.document(id).setData(data) { error in
                            if let error = error {
                                continuation.resume(throwing: error)
                            } else {
                                continuation.resume(returning: id)
                            }
                        }
                    } else {
                        let ref = try await collectionRef.addDocument(data: data)
                        continuation.resume(returning: ref.documentID)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
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

extension FirestoreProvider {
    /// Atualiza apenas campos específicos de um documento no Firestore
    func updateFields(
        in collection: String,
        id: String,
        fields: [String: Any]
    ) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            db.collection(collection).document(id).updateData(fields) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: true)
                }
            }
        }
    }
}

extension FirestoreProvider {

    /// Deleta um usuário e todas as subcoleções associadas (animais e suas subcoleções).
    func deleteUserCollections(userId: String) async throws {
        let userRef = db.collection("users").document(userId)

        // 🔹 1. Deleta todos os animais e subcoleções dentro deles
        try await deleteAnimals(of: userId)

        // 🔹 2. Deleta o documento principal do usuário
        try await userRef.delete()
    }

    /// Deleta a subcoleção "animals" e tudo que está dentro de cada animal.
    func deleteAnimals(of userId: String) async throws {
        let animalsRef = db.collection("users").document(userId).collection("animals")
        let animalsSnapshot = try await animalsRef.getDocuments()

        for animal in animalsSnapshot.documents {
            let animalRef = animal.reference

            // Subcoleções conhecidas dentro de cada animal
            let subcollections = ["vaccines", "medications", "annotations", "weights"]

            for sub in subcollections {
                try await deleteCollection("\(animalRef.path)/\(sub)", batchSize: 20)
            }

            // Por fim, deleta o documento do animal
            try await animalRef.delete()
        }
    }

    /// Deleta todos os documentos de uma coleção (usada internamente)
    private func deleteCollection(_ collectionPath: String, batchSize: Int = 20) async throws {
        let collectionRef = db.collection(collectionPath)

        while true {
            let snapshot = try await collectionRef.limit(to: batchSize).getDocuments()
            let documents = snapshot.documents

            guard !documents.isEmpty else { break }

            for document in documents {
                try await document.reference.delete()
            }
        }
    }
}
