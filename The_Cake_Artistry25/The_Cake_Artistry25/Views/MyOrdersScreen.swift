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
    @State private var cakeNames: [String: String] = [:] // Dictionary to store cake IDs and names
    
    // Date formatter for displaying the timestamp
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            List {
                if orderVM.orders.isEmpty {
                    VStack(alignment: .center) {
                        Text("You haven't placed any orders yet.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(orderVM.orders) { order in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Order ID: \(order.id ?? "N/A")")
                                .font(.headline)
                            
                            // Display the cake name if available, otherwise show the ID
                            Text("Cake: \(cakeNames[order.cakeID] ?? "Fetching...")")
                                .font(.subheadline)
                                .onAppear {
                                    // Fetch the cake name when the view appears
                                    fetchCakeName(for: order.cakeID)
                                }
                            Text("Price: $\(order.totalPrice, specifier: "%.2f")")
                                .font(.subheadline)
                            
                            Text("Flavour: \(order.flavor)")
                                .font(.subheadline)
                            
                            Text("Quantity: \(order.quantity)")
                                .font(.subheadline)
                                
                            // Display the new timestamp property
                            Text("Ordered On: \(order.timestamp, formatter: dateFormatter)")
                                .font(.subheadline)
                            
                            // Display the optional customization property if it exists
                            if let customization = order.customization {
                                Text("Customization: \(customization)")
                                    .font(.subheadline)
                            }
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
