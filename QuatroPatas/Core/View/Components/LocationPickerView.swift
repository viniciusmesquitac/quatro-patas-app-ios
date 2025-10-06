//
//  LocationPickerView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 05/10/25.
//
import SwiftUI
import CoreLocation
import MapKit

struct LocationPickerView: View {
    @Binding var address: String
    @State private var isLoading = false
    @State private var showMapPicker = false
    @State private var locationManager = CLLocationManager()
    @StateObject private var delegate = LocationDelegate()
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("Localização atual", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    fetchCurrentLocation()
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "location.fill")
                            .foregroundColor(.primaryColor)
                    }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
            
            Button {
                showMapPicker.toggle()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "map.fill")
                    Text("Escolher no mapa")
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primaryColor)
            }
            .padding(.top, 4)
        }
        .onAppear {
            locationManager.delegate = delegate
            delegate.onLocationUpdate = { location in
                handleLocation(location)
            }
        }
        .sheet(isPresented: $showMapPicker) {
            NavigationStack {
                MapPickerSheet(address: $address)
            }
        }
    }
    
    private func fetchCurrentLocation() {
        isLoading = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func handleLocation(_ location: CLLocation?) {
        guard let location else {
            toast("Não foi possível obter a localização", .error)
            isLoading = false
            return
        }
        reverseGeocode(location)
    }
    
    private func reverseGeocode(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            DispatchQueue.main.async {
                isLoading = false
                if let placemark = placemarks?.first {
                    let cep = placemark.postalCode ?? ""
                    let street = placemark.thoroughfare ?? ""
                    let number = placemark.subThoroughfare ?? ""
                    let city = placemark.locality ?? ""
                    
                    address = "\(street), \(number) - \(city), \(cep)"
                } else {
                    toast("Não foi possível encontrar o endereço", .error)
                }
            }
        }
    }
}

final class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    var onLocationUpdate: ((CLLocation?) -> Void)?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onLocationUpdate?(locations.first)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationUpdate?(nil)
    }
}
