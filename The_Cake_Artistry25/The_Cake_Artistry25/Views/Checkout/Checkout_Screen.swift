//
//  Checkout_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct CheckoutScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var orderVM = OrderViewModel()
    
    var cake: Cake
    var customizationText: String
    var quantity: Int
    
    @State private var showingOrderConfirmation = false
    @State private var placedOrder: Order?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Order Summary")
                .font(.largeTitle)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(cake.name).font(.title3)
                Text("Quantity: \(quantity)")
                Text("Customization: \(customizationText.isEmpty ? "None" : customizationText)")
                Text("Total: $\(cake.price * Double(quantity), specifier: "%.2f")")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            if orderVM.isPlacingOrder {
                ProgressView("Placing Order...")
            } else {
                Button("Place Order") {
                    guard let userID = authViewModel.user?.id else {
                        // Handle not logged in state
                        return
                    }
                    let newOrder = Order(
                        id: UUID().uuidString,
                        cakeID: cake.id,
                        userID: userID,
                        quantity: quantity,
                        timestamp: Date(),
                        customization: customizationText
                    )
                    orderVM.placeOrder(order: newOrder)
                    self.placedOrder = newOrder
                    showingOrderConfirmation = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Checkout")
        .alert(isPresented: $showingOrderConfirmation) {
            if let order = placedOrder, orderVM.orderError == nil {
                return Alert(
                    title: Text("Order Placed!"),
                    message: Text("Your order has been placed successfully."),
                    dismissButton: .default(Text("OK"), action: {
                        // Navigate to order tracking screen
                    })
                )
            } else {
                return Alert(
                    title: Text("Error Placing Order"),
                    message: Text(orderVM.orderError?.localizedDescription ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
