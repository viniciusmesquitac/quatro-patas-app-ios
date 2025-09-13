//
//  RouteDestinationView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 06/08/25.
//

import SwiftUI

struct RouteDestinationView: View {
    let route: Route
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        switch route {
        case .animals: AnimalsView()
        case .details(let animal): AnimalDetailView(animal: animal)
        case .menu: MenuView()
        case .adoption:  AdoptionView()
        case .adoptionForm: AdoptionFormView()
        case .formPage(let form): FormPageView(form: form)
        case .animalsList: AnimalsListView()
        case .addAnimal: AddAnimalView()
        case .edit(let animal, let years, let months): EditAnimalView(animal: animal, years: years, months: months)
        case .webView(let url): WebViewContainer(url: url)
        }
    }
}

extension View {
    func applyRoute() -> some View {
        self.navigationDestination(for: Route.self) { route in
            RouteDestinationView(route: route)
        }
    }
}
