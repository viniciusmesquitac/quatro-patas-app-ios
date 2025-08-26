//
//  Question.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/08/25.
//

import SwiftUI

struct Question: Decodable, Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    let type: QuestionType
    let options: [String]?
}

enum QuestionType: String, Decodable {
    case shortAnswer = "short_answer"
    case longAnswer = "long_answer"
    case singleSelection = "single_selection"
}
