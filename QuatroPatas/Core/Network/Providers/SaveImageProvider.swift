//
//  SaveImageProvider.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 23/02/26.
//

import UIKit

struct SaveImageProvider {

    let provider: any SACache

    init (provider: SACache) {
        self.provider = provider
    }

    func saveImageData(url: URL) {
        let token = url.getImageToken()
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                try? provider.save(data, for: token)
            }
        }.resume()
    }
}

extension URL {
    func getImageToken() -> String {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value else {
            return self.absoluteString
        }
        return token
    }
}
