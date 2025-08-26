//
//  GoogleFormsService.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 26/08/25.
//


import SwiftUI

struct GoogleFormsService {
    // URL de envio específica para seu formulário
    private let formURL = "https://docs.google.com/forms/d/e/1FAIpQLSdGudwF9f1YkSikuGZqY8FOhPgXwgWTNNAHYvgHJgv1DDeZ1A/formResponse"
    
    /// Envia respostas para o formulário
    func submitForm(answers: [String: String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: formURL) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Monta os parâmetros "entry.XXXXX" no corpo da requisição
        let bodyString = answers.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }.joined(separator: "&")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }.resume()
    }
}
