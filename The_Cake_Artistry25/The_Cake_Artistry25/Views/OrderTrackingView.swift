//
//  OrderTrackingView.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-08-01.
//
import SwiftUI
import MapKit

struct OrderTrackingView: View {
    @StateObject private var vm: OrderTrackingViewModel

    init(orderId: String) {
        _vm = StateObject(wrappedValue: OrderTrackingViewModel(orderId: orderId))
    }

    var body: some View {
        Map(position: $vm.cameraPosition) {
            if let d = vm.driverLocation {
                Annotation("Driver", coordinate: d) {
                    ZStack {
                        Circle().fill(.blue).frame(width: 16, height: 16)
                        Image(systemName: "car.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 9, weight: .bold))
                    }
                }
            }
            if let u = vm.userLocation {
                Annotation("You", coordinate: u) {
                    ZStack {
                        Circle().fill(.red).frame(width: 16, height: 16)
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 9, weight: .bold))
                    }
                }
            }
            if vm.route.count > 1 {
                MapPolyline(coordinates: vm.route)
                    .stroke(.blue, lineWidth: 3)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Track Your Order")
        .toolbar {
            // Optional: simulate movement in the simulator
            ToolbarItem(placement: .bottomBar) {
                Button("Simulate Route") {
                    let sample: [CLLocationCoordinate2D] = [
                        .init(latitude: 43.6532, longitude: -79.3832), // Toronto core
                        .init(latitude: 43.6600, longitude: -79.3900),
                        .init(latitude: 43.6700, longitude: -79.4000),
                        .init(latitude: 43.6800, longitude: -79.4100),
                        .init(latitude: 43.6900, longitude: -79.4150),
                        .init(latitude: 43.7001, longitude: -79.4163)  
                    ]
                    vm.simulateDriverPath(sample, interval: 1.0)
                }
            }
        }
        .onAppear { vm.start() }
    }
}

#Preview {
    NavigationStack {
        OrderTrackingView(orderId: "demo-order-123")
    }
}
