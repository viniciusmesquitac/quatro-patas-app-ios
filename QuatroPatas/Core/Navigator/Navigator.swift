//
//  Navigator.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

class Navigator: ObservableObject {

    @Published var path = NavigationPath()
    @Published var presentedSheet: Sheet? = nil
    @Published var parameters: [String: Any] = [:]

    func navigate(to route: Route) {
        path.append(route)
    }

    func present(sheet: Sheet) {
        presentedSheet = sheet
    }

    func dismiss() {
        if presentedSheet != nil {
            presentedSheet = nil
        } else if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

