//
//  Navigator.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 27/07/25.
//

import SwiftUI

class Navigator: ObservableObject {

    @Published var path = NavigationPath()
    @Published var routes: [Route] = []
    @Published var presentedSheet: Sheet? = nil
    @Published var parameters: [String: Any] = [:]
    
    private var sheetCallbacks: [String: (Any?) -> Void] = [:]
    private var routeCallbacks: [String: (Any?) -> Void] = [:]

    func navigate(to route: Route, onDismiss: ((Any?) -> Void)? = nil) {
        path.append(route)
        routes.append(route)

        if let callback = onDismiss {
            routeCallbacks[route.id] = callback
        }
    }

    func present(sheet: Sheet, onDismiss: ((Any?) -> Void)? = nil) {
        presentedSheet = sheet

        if let callback = onDismiss {
            sheetCallbacks[sheet.id] = callback
        }
    }

    func dismiss(data: Any? = nil) {
        if let sheet = presentedSheet {
            sheetCallbacks[sheet.id]?(data)
            sheetCallbacks[sheet.id] = nil

            presentedSheet = nil
        }
        else if let route = routes.last {
            routeCallbacks[route.id]?(data)
            sheetCallbacks[route.id] = nil
            path.removeLast()
            routes.removeLast()
        }
    }

    func popToRoot() {
        routes.removeLast(routes.count)
        path.removeLast(path.count)
    }
}

