//
//  CheckoutScreen.swift
//  The_Cake_Artistry25
//
//  Created by Gemini on 2025-08-01.
//

import SwiftUI
import CoreLocation

// The CheckoutScreen View
struct CheckoutScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var checkoutVM: CheckoutViewModel
    
    // The correct LocationManager with search capabilities
    @StateObject private var locationManager = LocationManager()
    
    var cake: Cake
    var customizationText: String
    var quantity: Int
    var flavor: String
    var orderDate: Date
    var orderTime: Date
    
    // State for location search and manual selection
    @State private var searchQuery: String = ""
    @State private var selectedAddress: String?
    @State private var showingOrderConfirmation = false
    
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
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Delivery Address")
                            .font(.headline)
                        
                        if let finalAddress = selectedAddress {
                            Text(finalAddress)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                        }
                        
                        TextField("Search for your address in Canada...", text: $searchQuery)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.top, 5)
                            .onChange(of: searchQuery) { newValue in
                                locationManager.search(query: newValue)
                            }
                        
                        if !locationManager.searchResults.isEmpty {
                            List(locationManager.searchResults, id: \.self) { placemark in
                                Button(action: {
                                    self.selectedAddress = locationManager.formatAddress(placemark)
                                    // Clear search results after selection
                                    locationManager.searchResults = []
                                    self.searchQuery = "" // Clear the search bar
                                }) {
                                    VStack(alignment: .leading) {
                                        Text(placemark.name ?? "Unknown Place")
                                            .font(.headline)
                                        Text(locationManager.formatAddress(placemark))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(10)
                            .listStyle(.plain)
                        }
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
                
                if checkoutVM.isProcessingOrder {
                    ProgressView("Placing Order...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(1.2)
                        .padding()
                } else {
                    Button(action: {
                        guard authViewModel.user != nil else { return }
                        
                        let addressToUse = selectedAddress
                        
                        checkoutVM.checkout(
                            cake: cake,
                            quantity: quantity,
                            flavor: flavor,
                            orderDate: orderDate,
                            orderTime: orderTime,
                            customization: customizationText,
                            address: addressToUse
                        )
                    }) {
                        Text("Order Now")
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
        .onChange(of: checkoutVM.orderSuccess) { success in
            if success {
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
