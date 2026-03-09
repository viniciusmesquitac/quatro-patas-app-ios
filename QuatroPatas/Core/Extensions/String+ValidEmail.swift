//
//  String+ValidEmail.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/03/26.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        return self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
}
