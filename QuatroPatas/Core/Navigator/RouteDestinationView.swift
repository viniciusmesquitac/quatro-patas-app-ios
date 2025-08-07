//
//  RouteDestinationView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/08/25.
//

import SwiftUI

struct RouteDestinationView: View {
    let route: Route

    var body: some View {
        switch route {
        case .animals:
            AnimalsView()
        case .details(let animal):
            AnimalDetailView(animal: animal)
        case .profile:
            ProfileView()
        case .adoption:
            AdoptionView()
        }
    }
}

extension View {
    func applyNavigationDestination() -> some View {
        self.navigationDestination(for: Route.self) { route in
            RouteDestinationView(route: route)
        }
    }
}
