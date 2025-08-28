//
//  RequestProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/08/25.
//

import SwiftUI
import Combine

final class RequestProvider: ObservableObject {

    func post(url: String, parameters: [String: String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let bodyString = parameters
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }.resume()
    }
    
    func get(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(URLError(.unknown)))
                }
            }
        }.resume()
    }
}
