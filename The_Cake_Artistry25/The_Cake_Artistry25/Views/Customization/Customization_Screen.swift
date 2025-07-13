//
//  Customization_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Customization_Screen: View {
    let cake: Cake
    let quantity: Int
    let deliveryDate: Date
    
    @State private var message = ""
    @State private var selectedFlavor = "Vanilla"
    @State private var selectedFrosting = "Buttercream"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Order Summary")) {
                    Text("\(cake.name) x \(quantity)")
                    Text("Total: $\(cake.price * Double(quantity), specifier: "%.2f")")
                    Text("Delivery: \(deliveryDate.formatted(date: .abbreviated, time: .omitted))")
                }
                
                Section(header: Text("Customization")) {
                    Picker("Flavor", selection: $selectedFlavor) {
                        Text("Vanilla").tag("Vanilla")
                        Text("Chocolate").tag("Chocolate")
                        Text("Red Velvet").tag("Red Velvet")
                    }
                    
                    Picker("Frosting", selection: $selectedFrosting) {
                        Text("Buttercream").tag("Buttercream")
                        Text("Cream Cheese").tag("Cream Cheese")
                        Text("Fondant").tag("Fondant")
                    }
                    
                    TextField("Special Message", text: $message, axis: .vertical)
                }
                
                Section {
                    NavigationLink {
                        Checkout_Screen(
                            cake: cake,
                            quantity: quantity,
                            deliveryDate: deliveryDate,
                            customization: [
                                "flavor": selectedFlavor,
                                "frosting": selectedFrosting,
                                "message": message
                            ]
                        )
                    } label: {
                        Text("Proceed to Checkout")
                    }
                }
            }
            .navigationTitle("Customize Your Cake")
        }
    }
}

#Preview {
    Customization_Screen(
        cake: Cake(
            id: "1",
            name: "Sample Cake",
            description: "Delicious cake",
            imageURL: "https://example.com/cake.jpg",
            price: 29.99,
            category: "Sample"
        ),
        quantity: 2,
        deliveryDate: Date()
    )
}
