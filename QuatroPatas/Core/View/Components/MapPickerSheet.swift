//
//  MapPickerSheet.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/10/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct InteractiveMap: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var pinAnimation: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapTapped(_:)))
        mapView.addGestureRecognizer(tap)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        context.coordinator.parent = self
        
        uiView.removeAnnotations(uiView.annotations)
        if let coordinate = selectedCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: InteractiveMap

        init(parent: InteractiveMap) {
            self.parent = parent
        }

        @objc func mapTapped(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

            DispatchQueue.main.async {
                self.parent.selectedCoordinate = coordinate
                self.parent.region.center = coordinate

                withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                    self.parent.pinAnimation.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                        self.parent.pinAnimation.toggle()
                    }
                }
            }
        }
    }
}

struct MapPickerSheet: View {
    @EnvironmentObject var navigator: Navigator
    @Binding var address: String

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -3.7319, longitude: -38.5267),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isLoading = false
    @State private var pinAnimation = false
    @Environment(\.toast) var toast
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            ZStack {
                InteractiveMap(region: $region, selectedCoordinate: $selectedCoordinate, pinAnimation: $pinAnimation)

                if isLoading {
                    LoadingView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirmar") {
                        if let coordinate = selectedCoordinate {
                            fetchAddress(for: coordinate)
                        } else {
                            toast("Selecione um ponto no mapa", .warning)
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { navigator.dismiss() }
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
            .onReceive(locationManager.$lastLocation) { location in
                guard let location = location else { return }
                region.center = location.coordinate
                selectedCoordinate = location.coordinate
            }
        }
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

struct MapPinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

@MainActor
final class LocationManager: NSObject, ObservableObject, @MainActor CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        authorizationStatus = manager.authorizationStatus
    }
    
    // MARK: - Public
    
    func requestLocation() {
        errorMessage = nil
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true
            manager.requestLocation() // one-shot
            
        case .denied, .restricted:
            errorMessage = "Permissão de localização negada. Ative em Ajustes > Privacidade."
            
        @unknown default:
            errorMessage = "Status de localização desconhecido."
        }
    }
    
    /// Retorna "Cidade, UF" usando a última localização disponível.
    /// Se ainda não tiver, você pode chamar `requestLocation()` antes e aguardar `lastLocation`.
    func getCityStateString() async throws -> String {
        guard let lastLocation else {
            throw NSError(domain: "Location", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Localização ainda não disponível."
            ])
        }
        
        let placemarks = try await geocoder.reverseGeocodeLocation(lastLocation)
        let pm = placemarks.first
        
        let city = pm?.locality ?? pm?.subAdministrativeArea ?? "Cidade"
        let state = pm?.administrativeArea ?? "UF"
        
        return "\(city), \(state)"
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true
            manager.requestLocation()
            
        case .denied, .restricted:
            isLoading = false
            errorMessage = "Permissão de localização negada. Ative em Ajustes > Privacidade."
            
        case .notDetermined:
            break
            
        @unknown default:
            isLoading = false
            errorMessage = "Status de localização desconhecido."
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isLoading = false
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = "Erro ao obter localização: \(error.localizedDescription)"
    }
}
