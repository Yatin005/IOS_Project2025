//
//  OrderTrackingView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//

import SwiftUI
import MapKit

struct OrderTrackingView: View {
    // Simulate live coordinates for demonstration
    @State private var driverLocation = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
    @State private var userLocation = CLLocationCoordinate2D(latitude: 43.7001, longitude: -79.4163)
    @State private var historicalRoute: [CLLocationCoordinate2D] = []
    @State private var region: MKCoordinateRegion

    init() {
        // Initial region to show both driver and user
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.6766, longitude: -79.3997),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: [
                Location(name: "Driver", coordinate: driverLocation),
                Location(name: "You", coordinate: userLocation)
            ]) { location in
                MapPin(coordinate: location.coordinate, tint: location.name == "Driver" ? .blue : .red)
            }
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Spacer()
                    Button("View Historical Route (Backtracking)") {
                        // Simulate fetching a historical route from Firestore
                        // In a real app, this would come from your backend
                        self.historicalRoute = [
                            CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
                            CLLocationCoordinate2D(latitude: 43.6700, longitude: -79.3900),
                            CLLocationCoordinate2D(latitude: 43.6850, longitude: -79.4050),
                            CLLocationCoordinate2D(latitude: 43.7001, longitude: -79.4163)
                        ]
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 20)
                }
            )
            .onAppear {
                // Here, you would fetch real-time driver location and user location
                // and update the 'driverLocation' and 'userLocation' state variables.
                // You would also set up a timer or a Firebase listener for real-time updates.
            }
        }
        .navigationTitle("Track Your Order")
    }
}

// A simple Identifiable struct for map annotations
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
#Preview {
    OrderTrackingView()
}
