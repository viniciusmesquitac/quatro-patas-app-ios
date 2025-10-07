//
//  Question.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 24/08/25.
//

import SwiftUI

struct Question: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String?
    let placeholder: String?
    let type: QuestionType
    let options: [String]?
}

enum QuestionType: String, Decodable {
    case shortAnswer = "short_answer"
    case longAnswer = "long_answer"
    case singleSelection = "single_selection"
    case age
    case email
    case phone
    case location
    case date
    case imageUpload = "image_upload"
}
