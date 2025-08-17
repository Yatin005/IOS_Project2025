//
//  LocationManager.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-08-01.
//

import Foundation
import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var searchResults: [CLPlacemark] = []
    @Published var isSearching = false
    @Published var regionStatusMessage: String?
    @Published var authorizationStatus: CLAuthorizationStatus?

    private var monitoredRegion: CLCircularRegion?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .denied || status == .restricted {
            regionStatusMessage = "Location access denied. Enable it in Settings."
        }
    }

    // MARK: - Region monitoring callbacks
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLCircularRegion else { return }
        DispatchQueue.main.async { self.regionStatusMessage = "You have arrived at your destination!" }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLCircularRegion else { return }
        DispatchQueue.main.async { self.regionStatusMessage = "You have left the destination." }
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Region monitoring failed: \(error.localizedDescription)")
        DispatchQueue.main.async { self.regionStatusMessage = "Geofencing failed: \(error.localizedDescription)" }
    }

    // MARK: - Search (POI-first with fallback to address geocoding)
    func search(query: String) {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        searchResults = []
        guard !q.isEmpty else { return }

        isSearching = true
        geocoder.cancelGeocode()

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = q
        if let loc = locationManager.location {
           
            request.region = MKCoordinateRegion(
                center: loc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
            )
        }

        MKLocalSearch(request: request).start { [weak self] response, error in
            guard let self = self else { return }
            if let items = response?.mapItems, !items.isEmpty {
                DispatchQueue.main.async {
                    self.searchResults = items.map { $0.placemark } // MKPlacemark is a
                    self.isSearching = false
                }
                return
            }

            self.geocoder.geocodeAddressString(q) { placemarks, geoError in
                DispatchQueue.main.async {
                    self.isSearching = false
                    if let geoError = geoError {
                        print("Geocoding error: \(geoError.localizedDescription)")
                        self.searchResults = []
                    } else {
                        self.searchResults = placemarks ?? []
                    }
                }
            }
        }
    }

    // MARK: - Geofencing
    func startMonitoring(for placemark: CLPlacemark) {
        stopMonitoring()

        guard let location = placemark.location else {
            regionStatusMessage = "Cannot get location from placemark."
            return
        }

        // Geofencing background monitoring needs "Always"
        if locationManager.authorizationStatus != .authorizedAlways {
            regionStatusMessage = "Requesting 'Always' permission for background geofencing."
            locationManager.requestAlwaysAuthorization()
        }

        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            regionStatusMessage = "Geofencing not available on this device."
            return
        }

        let region = CLCircularRegion(center: location.coordinate, radius: 100, identifier: "destinationRegion")
        region.notifyOnEntry = true
        region.notifyOnExit = true

        monitoredRegion = region
        locationManager.startMonitoring(for: region)

        DispatchQueue.main.async {
            self.regionStatusMessage = "Monitoring: \(self.formatAddress(placemark))"
            print("Started monitoring region: \(region.identifier)")
        }
    }

    func stopMonitoring() {
        if let region = monitoredRegion {
            locationManager.stopMonitoring(for: region)
            monitoredRegion = nil
            print("Stopped monitoring region: \(region.identifier)")
            DispatchQueue.main.async { self.regionStatusMessage = "Monitoring stopped." }
        }
    }

    // MARK: - Helpers
    func formatAddress(_ placemark: CLPlacemark) -> String {
        var parts: [String] = []
        if let name = placemark.name { parts.append(name) }
        if let street = placemark.thoroughfare { parts.append(street) }
        if let city = placemark.locality { parts.append(city) }
        if let state = placemark.administrativeArea { parts.append(state) }
        if let postalCode = placemark.postalCode { parts.append(postalCode) }
        if let country = placemark.country { parts.append(country) }
        return parts.joined(separator: ", ")
    }
}
