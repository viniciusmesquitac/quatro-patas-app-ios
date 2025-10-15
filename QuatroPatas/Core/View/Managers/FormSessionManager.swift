//
//  FormSessionManager.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 15/10/25.
//

import SwiftUI

class FormSessionManager: ObservableObject {
    @Published var responses: [String: String] = [:]
    @Published var continueKey: String? = nil
    @Published var page: Int = 1
    
    func update(from bodyString: String) {
        let pairs = bodyString.split(separator: "&")
        for pair in pairs {
            let keyValue = pair.split(separator: "=", maxSplits: 1)
            if keyValue.count == 2 {
                let key = String(keyValue[0])
                let value = String(keyValue[1]).removingPercentEncoding ?? ""
                
                if key == "continue" {
                    continueKey = value
                } else {
                    responses[key] = value
                }
            }
        }
    }

    func encodedBody(isContinuing: Bool = true) -> Data? {
        var components: [String] = []
        
        // 1. Adiciona respostas em ordem alfabética (melhor previsibilidade)
        let sortedKeys = responses.keys.sorted()
        for key in sortedKeys {
            if let value = responses[key] {
                components.append("\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
                
                // 2. Adiciona campos _sentinel para entradas (Google Forms exige)
                if key.starts(with: "entry.") {
                    components.append("\(key)_sentinel=")
                }
            }
        }
        
        // 3. Campos fixos do Google Forms
        components.append("fvv=1")
        if let partial = responses["partialResponse"] {
            components.append("partialResponse=\(partial)")
        }
        components.append("pageHistory=0")
        components.append("fbzx=\(responses["fbzx"] ?? "")")
        components.append("submissionTimestamp=-1")

        // 4. Inclui continue ou back
        if isContinuing {
            if let cont = continueKey {
                components.append("continue=\(cont)")
                if let index = components.firstIndex(of: "back=1") {
                    components.remove(at: index)
                }
            }
        } else {
            components.append("back=1")
        }
        
        let bodyString = components.joined(separator: "&")
        return bodyString.data(using: .utf8)
    }

}
