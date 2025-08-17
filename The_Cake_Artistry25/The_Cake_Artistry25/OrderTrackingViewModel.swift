//
//  OrderTrackingViewModel.swift
//  The_Cake_Artistry25
//
//  
//

import SwiftUI
import Foundation
import MapKit
import FirebaseFirestore
import CoreLocation

final class OrderTrackingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Inputs
    let orderId: String

    // Outputs (bind to UI)
    @Published var driverLocation: CLLocationCoordinate2D?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var route: [CLLocationCoordinate2D] = []
    @Published var cameraPosition: MapCameraPosition = .automatic

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let locationManager = CLLocationManager()

    init(orderId: String) {
        self.orderId = orderId
        super.init()
        // Ask for user location (for "You" pin)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    deinit {
        listener?.remove()
        locationManager.stopUpdatingLocation()
    }

    func start() {
        let doc = db.collection("orders")
            .document(orderId)
            .collection("tracking")
            .document("current")

        listener = doc.addSnapshotListener { [weak self] snap, error in
            guard let self = self else { return }
            if let error = error {
                print("Tracking listener error:", error.localizedDescription)
                return
            }
            guard let data = snap?.data() else { return }

            // Parse driver location (supports multiple shapes)
            if let gp = data["driver"] as? GeoPoint {
                self.setDriver(CLLocationCoordinate2D(latitude: gp.latitude, longitude: gp.longitude))
            } else if
                let lat = data["driverLat"] as? CLLocationDegrees,
                let lng = data["driverLng"] as? CLLocationDegrees {
                self.setDriver(CLLocationCoordinate2D(latitude: lat, longitude: lng))
            }

            // Optional: user location provided by backend (fallback to device)
            if let ugp = data["user"] as? GeoPoint {
                self.userLocation = CLLocationCoordinate2D(latitude: ugp.latitude, longitude: ugp.longitude)
            }

            // Optional: full historical route from backend
            if let routeArray = data["route"] as? [GeoPoint] {
                self.route = routeArray.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            }

            self.updateCamera()
        }
    }

    private func setDriver(_ coord: CLLocationCoordinate2D) {
        driverLocation = coord
        // Build a simple route if backend didn't provide one
        if !route.isEmpty {
            // Append only if moved a meaningful distance
            if let last = route.last, distanceMeters(from: last, to: coord) > 5 {
                route.append(coord)
            }
        } else {
            route = [coord]
        }
    }

    private func distanceMeters(from a: CLLocationCoordinate2D, to b: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: a.latitude, longitude: a.longitude)
            .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
    }

    private func updateCamera() {
        // Prefer showing both "driver" and "you" if possible
        if let d = driverLocation, let u = userLocation {
            let minLat = min(d.latitude, u.latitude)
            let maxLat = max(d.latitude, u.latitude)
            let minLng = min(d.longitude, u.longitude)
            let maxLng = max(d.longitude, u.longitude)

            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2.0,
                                                longitude: (minLng + maxLng) / 2.0)
            let latSpan = max(0.01, (maxLat - minLat) * 1.8)
            let lngSpan = max(0.01, (maxLng - minLng) * 1.8)

            let region = MKCoordinateRegion(center: center,
                                            span: MKCoordinateSpan(latitudeDelta: latSpan, longitudeDelta: lngSpan))
            cameraPosition = .region(region)
        } else if let d = driverLocation {
            cameraPosition = .region(MKCoordinateRegion(center: d,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        } else if let u = userLocation {
            cameraPosition = .region(MKCoordinateRegion(center: u,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        }
    }

    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        userLocation = loc.coordinate
        updateCamera()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }

    // MARK: - Test helper: simulate driver moving (use in Simulator)
    func simulateDriverPath(_ coords: [CLLocationCoordinate2D], interval: TimeInterval = 1.2) {
        // Writes to Firestore so your consumer app sees movement in real-time
        let doc = db.collection("orders")
            .document(orderId)
            .collection("tracking")
            .document("current")

        Task { @MainActor in
            for c in coords {
                try? await doc.setData([
                    "driverLat": c.latitude,
                    "driverLng": c.longitude,
                    "updatedAt": FieldValue.serverTimestamp()
                ], merge: true)
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
    }
}
