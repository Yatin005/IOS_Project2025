//
//  LocationManager.swift
//  The_Cake_Artistry25
//
//  Created by Gemini on 2025-08-01.
//

import Foundation
import CoreLocation
import Combine

// The LocationManager is an ObservableObject to allow SwiftUI views to react to changes.
// It also conforms to CLLocationManagerDelegate to receive location events.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Core Location manager instance for requesting location authorization and updates.
    private let locationManager = CLLocationManager()
    
    // Geocoder to convert coordinates to an address, and vice versa.
    private let geocoder = CLGeocoder()
    
    // Published properties for real-time updates to views.
    // This property will store the results of an address search.
    @Published var searchResults: [CLPlacemark] = []
    
    // This property will track the current geofencing status.
    @Published var regionStatusMessage: String?
    
    // This property will track the current authorization status.
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    // A property to hold the region we are currently monitoring.
    private var monitoredRegion: CLCircularRegion?
    
    override init() {
        super.init()
        // Set this class as the delegate for the location manager.
        locationManager.delegate = self
        // Request "always" authorization from the user for geofencing.
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Location Authorization and Monitoring
    
    // This method is called when the location authorization status changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        if status == .denied || status == .restricted {
            self.regionStatusMessage = "Location access denied. Please enable in Settings for geofencing."
        }
    }
    
    // This method is called when the user enters a monitored region.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("You have entered the monitored region!")
            // You could trigger a local notification or other action here.
            DispatchQueue.main.async {
                self.regionStatusMessage = "You have arrived at your destination!"
            }
        }
    }
    
    // This method is called when the user exits a monitored region.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            print("You have exited the monitored region!")
            DispatchQueue.main.async {
                self.regionStatusMessage = "You have left the destination."
            }
        }
    }
    
    // This method is called if region monitoring fails.
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Region monitoring failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.regionStatusMessage = "Geofencing failed: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Address Searching and Geofencing
    
    // Function to search for an address based on a query string.
    func search(query: String) {
        self.searchResults = []
        guard !query.isEmpty else { return }
        
        let canadaRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 56.1304, longitude: -106.3468), radius: 5000000, identifier: "canadaRegion")
        
        geocoder.geocodeAddressString(query, in: canadaRegion) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self.searchResults = []
                    return
                }
                
                guard let placemarks = placemarks else {
                    self.searchResults = []
                    return
                }
                
                // Filter the results to only include those in Canada
                self.searchResults = placemarks.filter { $0.country == "Canada" }
            }
        }
    }
    
    // Function to start monitoring a geofence for a specific location.
    func startMonitoring(for placemark: CLPlacemark) {
        // Stop any existing monitoring before starting a new one.
        stopMonitoring()
        
        guard let location = placemark.location else {
            self.regionStatusMessage = "Cannot get location from placemark."
            return
        }
        
        let region = CLCircularRegion(center: location.coordinate, radius: 100, identifier: "destinationRegion")
        // Notify when the user enters and exits the region.
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        self.monitoredRegion = region
        locationManager.startMonitoring(for: region)
        
        DispatchQueue.main.async {
            self.regionStatusMessage = "Now monitoring region for: \(self.formatAddress(placemark))"
            print("Started monitoring region: \(region.identifier)")
        }
    }
    
    // Function to stop monitoring the current geofence.
    func stopMonitoring() {
        if let region = self.monitoredRegion {
            locationManager.stopMonitoring(for: region)
            self.monitoredRegion = nil
            print("Stopped monitoring region: \(region.identifier)")
            DispatchQueue.main.async {
                self.regionStatusMessage = "Monitoring stopped."
            }
        }
    }
    
    // MARK: - Helper Methods
    
    // Helper function to format the address from a CLPlacemark object into a single string.
    func formatAddress(_ placemark: CLPlacemark) -> String {
        var addressComponents: [String] = []
        if let street = placemark.thoroughfare { addressComponents.append(street) }
        if let city = placemark.locality { addressComponents.append(city) }
        if let state = placemark.administrativeArea { addressComponents.append(state) }
        if let postalCode = placemark.postalCode { addressComponents.append(postalCode) }
        if let country = placemark.country { addressComponents.append(country) }
        
        return addressComponents.joined(separator: ", ")
    }
}
