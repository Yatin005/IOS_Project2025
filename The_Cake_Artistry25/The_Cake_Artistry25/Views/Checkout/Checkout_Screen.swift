//
//  Checkout_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct Checkout_Screen: View {
    let cake: Cake
    let quantity: Int
    let deliveryDate: Date
    let customization: [String: String]
    
    @StateObject private var orderVM = OrderViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    @State private var deliveryAddress = ""
    @State private var showOrderConfirmation = false
    
    var body: some View {
        Form {
            Section(header: Text("Order Summary")) {
                Text("\(cake.name) x \(quantity)")
                Text("Total: $\(cake.price * Double(quantity), specifier: "%.2f")")
                Text("Delivery: \(deliveryDate.formatted(date: .abbreviated, time: .omitted))")
            }
            
            Section(header: Text("Customization")) {
                ForEach(customization.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    HStack {
                        Text(key.capitalized)
                        Spacer()
                        Text(value)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("Delivery Information")) {
                TextField("Delivery Address", text: $deliveryAddress, axis: .vertical)
            }
            
            Section {
                Button("Place Order") {
                    if let userId = authVM.user?.uid {
                        orderVM.placeOrder(
                            cake: cake,
                            quantity: quantity,
                            deliveryDate: deliveryDate,
                            customerId: userId
                        )
                        showOrderConfirmation = true
                    }
                }
                .disabled(deliveryAddress.isEmpty || orderVM.isLoading)
            }
        }
        .navigationTitle("Checkout")
        .alert("Order Placed!", isPresented: $showOrderConfirmation) {
            Button("OK", role: .cancel) {
                // Optionally navigate to order tracking
            }
        }
    }
}

#Preview {
    Checkout_Screen(
        cake: Cake(
            id: "1",
            name: "Sample Cake",
            description: "Delicious cake",
            imageURL: "https://example.com/cake.jpg",
            price: 29.99,
            category: "Sample"
        ),
        quantity: 2,
        deliveryDate: Date(),
        customization: ["flavor": "Chocolate", "frosting": "Buttercream"]
    )
    .environmentObject(AuthViewModel())
}
