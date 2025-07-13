//
//  OrderTracking_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct OrderTracking_Screen: View {
    @StateObject private var orderVM = OrderViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(orderVM.orders) { order in
                    VStack(alignment: .leading) {
                        Text(order.cake.name)
                            .font(.headline)
                        Text("Quantity: \(order.quantity)")
                        Text("Total: $\(order.cake.price * Double(order.quantity), specifier: "%.2f")")
                        Text("Status: \(order.status)")
                            .foregroundColor(statusColor(for: order.status))
                    }
                }
            }
            .navigationTitle("My Orders")
            .onAppear {
                if let userId = authVM.user?.uid {
                    orderVM.userId = userId
                    orderVM.fetchOrders()
                }
            }
            .overlay {
                if orderVM.isLoading {
                    ProgressView()
                }
            }
        }
    }
    
    private func statusColor(for status: String) -> Color {
        switch status {
        case "Processing": return .orange
        case "Shipped": return .blue
        case "Delivered": return .green
        case "Cancelled": return .red
        default: return .primary
        }
    }
}

#Preview {
    OrderTracking_Screen()
        .environmentObject(AuthViewModel())
}
