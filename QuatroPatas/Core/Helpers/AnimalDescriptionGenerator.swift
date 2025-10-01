//
//  AnimalDescriptionGenerator.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/09/25.
//

import SwiftUI

struct AnimalDescriptionGenerator {

    /// Gera a descrição casual e atualiza o binding
    static func generate(for animal: Binding<Animal>,
                         onError: (_ message: String) -> Void) {
        
        let a = animal.wrappedValue
        
        // Validação básica: campos obrigatórios
        guard !a.name.isEmpty,
              !a.type.isEmpty,
              !a.breed.isEmpty,
              !a.age.isEmpty,
              !a.size.isEmpty else {
            onError("Preencha todos os dados obrigatórios do animal antes de gerar a descrição.")
            return
        }

        let gender = a.gender.lowercased() == "male" ? "Ele" : "Ela"
        var parts: [String] = []

        // Introdução
        parts.append("Conheça \(a.name), um(a) \(a.type.lowercased()) \(a.breed.lowercased()) de porte \(a.size.lowercased()) e \(a.ageFormatted).")

        // Cor
        if !a.color.isEmpty {
            parts.append("Sua pelagem \(a.color.lowercased()) chama atenção!")
        }

        // Tags importantes
        let healthTags = ["vaccinated", "neutered", "microchipped"]
        var healthTexts: [String] = []

        for tag in healthTags {
            if a.tags.contains(tag) {
                switch tag {
                case "vaccinated": healthTexts.append("vacinado(a)")
                case "neutered": healthTexts.append("castrado(a)")
                case "microchipped": healthTexts.append("microchipado(a)")
                default: break
                }
            }
        }

        if !healthTexts.isEmpty {
            parts.append("\(gender) já está \(healthTexts.joined(separator: ", ")).")
        }

        // Doenças ou cuidados especiais
        let specialTags = ["fiv", "felv", "hipdysplasia", "specialNeeds"]
        let specialTagNames: [String: String] = [
            "fiv": "FIV",
            "felv": "FeLV",
            "hipdysplasia": "Displasia",
            "specialNeeds": "necessidades especiais"
        ]

        let detectedSpecials = a.tags.filter { specialTags.contains($0) }
        if !detectedSpecials.isEmpty {
            let specialText = detectedSpecials.map { specialTagNames[$0]! }.joined(separator: ", ")
            parts.append("Importante: \(gender.lowercased()) possui \(specialText), mas isso não impede que seja adotado(a) e amado(a) em um lar adequado.")
        }

        // Fechamento
        parts.append("Venha conhecê-lo(a) e dê um lar cheio de carinho!")

        // Atualiza o binding da descrição
        animal.description.wrappedValue = parts.joined(separator: " ")
    }
}
