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
        case .formPage(let form, let currentPage): FormPageView(form: form, currentPage: currentPage)
        case .animalsList(let type): AnimalsListView(listType: type)
        case .addAnimal(let type): AddAnimalView(addAnimalType: type)
        case .edit(let animal, let years, let months):
            EditAnimalView(animal: animal, years: years, months: months, editAnimalType: .ongAnimals)
        case .editMyAnimals(let animal, let years, let months): EditAnimalView(animal: animal, years: years, months: months, editAnimalType: .myAnimals)
        case .webView(let url): WebViewContainer(url: url)
        case .register: RegisterView()
        case .loginWithEmailAndPassword: LoginWithEmailAndPasswordView()
        case .seeAllAnimals(let animals):
            AnimalSectionListView(animals: animals)
        case .profile: ProfileView()
        case .personalInformation(let user): EditPersonalInformationView(user: user)
        case .myAnimalDetails(let animal): MyAnimalDetailsView(animal: animal)
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
