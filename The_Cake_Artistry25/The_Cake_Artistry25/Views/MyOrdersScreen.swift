//
//  MyOrdersScreen.swift
//  The_Cake_Artistry25
//
//  Created by Gemini on 2025-08-01.
//

import SwiftUI
import FirebaseFirestore

struct MyOrdersScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var orderVM = OrderViewModel()
    @StateObject var locationManager = LocationManager()
    @State private var cakeNames: [String: String] = [:] // Dictionary to store cake IDs and names
    
    // Date formatter for displaying the timestamp
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    // A private helper method to create the view for a single order.
    private func orderRowContent(for order: Order) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Order ID: \(order.id ?? "N/A")")
                .font(.headline)
            
            Text("Cake: \(cakeNames[order.cakeID] ?? "Fetching...")")
                .font(.subheadline)
            
            Text("Price: $\(order.totalPrice, specifier: "%.2f")")
                .font(.subheadline)
            
            Text("Flavour: \(order.flavor)")
                .font(.subheadline)
            
            Text("Quantity: \(order.quantity)")
                .font(.subheadline)
            
            Text("Ordered On: \(order.timestamp, formatter: dateFormatter)")
                .font(.subheadline)
            
            if let customization = order.customization {
                Text("Customization: \(customization)")
                    .font(.subheadline)
            }
            
            if let address = order.address {
                Text("Address: \(address)")
                    .font(.subheadline)
            }
        }
        .onAppear {
            fetchCakeName(for: order.cakeID)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Display the geofencing status message instead of a current address.
                if let statusMessage = locationManager.regionStatusMessage {
                    Section(header: Text("Geofencing Status")) {
                        Text(statusMessage)
                    }
                }
                
                if orderVM.orders.isEmpty {
                    VStack(alignment: .center) {
                        Text("You haven't placed any orders yet.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Section(header: Text("Order History")) {
                        ForEach(orderVM.orders) { order in
                            orderRowContent(for: order)
                        }
                    }
                }
            }
            .navigationTitle("My Orders")
            .onAppear {
                if let userID = authViewModel.user?.id {
                    orderVM.fetchOrders(for: userID)
                }
            }
        }
    }
    
    // Fetches the cake name from Firestore based on the cakeID
    private func fetchCakeName(for cakeID: String) {
        let db = Firestore.firestore()
        // Removed `[weak self]` as `MyOrdersScreen` is a struct (value type)
        db.collection("cakes").document(cakeID).getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let cakeName = document.data()?["name"] as? String {
                DispatchQueue.main.async {
                    self.cakeNames[cakeID] = cakeName
                }
            }
        }
    }
}

// MARK: - Preview Provider (for easy testing in Xcode)
#Preview {
    let mockAuthVM = AuthViewModel()
    return NavigationView {
        MyOrdersScreen()
            .environmentObject(mockAuthVM)
    }
}
