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
        case .animals: AnimalsView()
        case .details(let animal): AnimalDetailView(animal: animal)
        case .menu(let user): MenuView(user: user)
        case .adoption:  AdoptionView()
        case .adoptionForm: AdoptionFormView()
        case .formPage(let form): FormPageView(form: form)
        //case .donate: DonateView()
        case .animalsList: AnimalsListView()
        case .addAnimal: AddAnimalView()
        case .webView(let url): WebView(url)
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

import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
