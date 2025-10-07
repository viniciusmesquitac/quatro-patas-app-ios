//
//  MapPickerSheet.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/10/25.
//


import SwiftUI
import MapKit
import CoreLocation

struct MapPickerSheet: View {
    
    @EnvironmentObject var navigator: Navigator

    @Binding var address: String
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isLoading = false
    @Environment(\.toast) var toast
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(bounds: .none)
                .ignoresSafeArea()
                .gesture(DragGesture(minimumDistance: 0)
                    .onEnded { _ in updateSelectedCoordinate() })
                
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.primaryColor)
                    .offset(y: -20)
                
                if isLoading {
                    ProgressView("Buscando endereço...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .navigationTitle("Selecione no mapa")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirmar") {
                        if let coordinate = selectedCoordinate {
                            fetchAddress(for: coordinate)
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { navigator.dismiss() }
                }
            }
            .onAppear {
                selectedCoordinate = region.center
            }
        }
    }
    
    private func updateSelectedCoordinate() {
        selectedCoordinate = region.center
    }
    
    private func fetchAddress(for coordinate: CLLocationCoordinate2D) {
        isLoading = true
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            DispatchQueue.main.async {
                isLoading = false
                if let placemark = placemarks?.first {
                    let cep = placemark.postalCode ?? ""
                    let street = placemark.thoroughfare ?? ""
                    let number = placemark.subThoroughfare ?? ""
                    let city = placemark.locality ?? ""
                    
                    address = "\(street), \(number) - \(city), \(cep)"
                    navigator.dismiss()
                } else {
                    toast("Não foi possível obter o endereço", .error)
                }
            }
        }
    }
}

struct MapAnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
