//
//  OrderTracking_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI
import FirebaseFirestore

struct OrderTrackingScreen: View {
    var order: Order
    
    @State private var cake: Cake?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Order #\(order.id)")
                .font(.largeTitle)
            
            if let cake = cake {
                VStack(alignment: .leading, spacing: 10) {
                    Text(cake.name).font(.headline)
                    Text("Quantity: \(order.quantity)")
                    Text("Customization: \(order.customization.isEmpty ? "None" : order.customization)")
                    Text("Ordered on: \(order.timestamp, formatter: DateFormatter.shortDate)")
                }
            } else {
                ProgressView("Loading cake details...")
            }
            
            Divider()
            
            Text("Current Status:")
                .font(.headline)
            Text("Your order is being processed and will be prepared soon. We will notify you when it's ready for pickup or delivery.")
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .onAppear {
            Firestore.firestore().collection("cakes").document(order.cakeID).getDocument { (snapshot, error) in
                if let data = snapshot?.data() {
                    self.cake = try? Firestore.Decoder().decode(Cake.self, from: data)
                }
            }
        }
        .navigationTitle("Track Order")
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
