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
        case .details(let animal): AnimalDetailView(animal: animal)
        case .favorites: FavoritesListView()
        case .addAnimal: AddAnimalView()
        case .edit(let animal):
            EditAnimalView(animal: animal)
        case .register: RegisterView()
        case .login: LoginView()
        case .loginWithEmailAndPassword: LoginWithEmailAndPasswordView()
        case .profile: ProfileView()
        case .personalInformation(let user): EditPersonalInformationView(user: user)
        case .formsInformation(let user): EditFormsInformationView(user: user)
        case .animalWallet(let animal): AnimalWalletView(animal: animal)
        case .vaccineList(let animalId): VaccineListView(animalId: animalId)
        case .medicationList(let animalId): MedicationListView(animalId: animalId)
        case .registerAdoption(let animalId): RegisterAdoption(animalId: animalId)
        case .adoptionDetails(let animalId): AdoptionDetailsView(animalId: animalId)
        case .weightChart(let animalId): WeightChartView(animalId: animalId)
        case .annotationList(let animalId): AnnotationListView(animalId: animalId)
        case .annotationDetails(let annotation, let animalId): AnnotationDetailsView(annotation: annotation, animalId: animalId)
        case .reportMissingAnimal: ReportMissingAnimalView()
        case .forgotPassword: ForgotPasswordView()
        case .ngoDetails(let ngo): NGODetailsView(ngo: ngo)
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
