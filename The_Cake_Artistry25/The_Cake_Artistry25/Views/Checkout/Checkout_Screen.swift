//
//  Checkout_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Checkout_Screen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var orderVM = OrderViewModel()
    
    var cake: Cake
    var customizationText: String
    var quantity: Int
    var flavor: String = "Chocolate"
    
    @State private var showingOrderConfirmation = false
    @State private var placedOrder: Order?
    
    var totalPrice: Double {
        cake.price * Double(quantity)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text("Order Summary")
                    .font(.custom("Montserrat", size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(Color.orange.opacity(0.8))
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 20) {
                        AsyncImage(url: URL(string: cake.imageUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .cornerRadius(15)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(cake.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Quantity: \(quantity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Price: $\(cake.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Customization")
                            .font(.headline)
                        
                        Text(customizationText.isEmpty ? "None" : customizationText)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
                
                HStack {
                    Text("Total Amount:")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("$\(totalPrice, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(15)
                
                Spacer()
                
                if orderVM.isPlacingOrder {
                    ProgressView("Placing Order...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(1.2)
                        .padding()
                } else {
                    Button(action: {
                        guard let userID = authViewModel.user?.id,
                              let cakeID = cake.id else {
                            return
                        }
                        
                        let newOrder = Order(
                            cakeID: cakeID,
                            userID: userID,
                            quantity: quantity,
                            timestamp: Date(),
                            customization: customizationText,
                            flavor: self.flavor,
                            totalPrice: self.totalPrice
                        )
                        
                        orderVM.placeOrder(order: newOrder)
                        self.placedOrder = newOrder
                    }) {
                        Text("Place Order")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
            }
            .padding()
            .navigationTitle("Checkout")
        }
        .onChange(of: orderVM.isPlacingOrder) { oldValue, newValue in
            if oldValue == true && newValue == false {
                self.showingOrderConfirmation = true
            }
        }
        .alert(isPresented: $showingOrderConfirmation) {
            Alert(
                title: Text("Order Placed! 🥳"),
                message: Text("Your order has been placed successfully."),
                dismissButton: .default(Text("OK")) {
                    dismiss()
                }
            )
        }
        .onAppear {
            print("CheckoutScreen appeared with cake: \(cake.name)")
        }
    }
}


// MARK: - Preview Provider (for easy testing in Xcode)
#Preview {
    let mockCake = Cake(
        id: "mock_id",
        name: "Chocolate Fudge Cake", description: "Good",
        imageUrl: "https://placehold.co/100x100/A08880/ffffff?text=Cake",
        price: 35.50,
        category: "Classic"
    )
    
    let mockAuthVM = AuthViewModel()
    
    NavigationView {
        Checkout_Screen(
            cake: mockCake,
            customizationText: "Happy Birthday John!",
            quantity: 2
        )
        .environmentObject(mockAuthVM)
    }
}
