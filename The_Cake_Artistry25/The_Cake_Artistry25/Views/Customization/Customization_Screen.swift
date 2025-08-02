//
//  Customization_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct CustomizationScreen: View {
    var cake: Cake
    
    // State variables for customization
    @State private var customizationText = ""
    @State private var quantity = 1
    @State private var selectedFlavor = "Vanilla"
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    
    // Flavor options
    private let flavors = ["Vanilla", "Chocolate", "Strawberry", "Red Velvet"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(cake.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                AsyncImage(url: URL(string: cake.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(10)
                
                Text("Customize Your Cake")
                    .font(.headline)
                
                // Flavor Picker
                Picker("Flavor", selection: $selectedFlavor) {
                    ForEach(flavors, id: \.self) { flavor in
                        Text(flavor).tag(flavor)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Customization Text Field
                TextField("Custom message or instructions", text: $customizationText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Quantity Stepper
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...20)
                    .padding(.horizontal)
                
                // Date Picker
                DatePicker("Order Date", selection: $selectedDate, displayedComponents: .date)
                    .padding(.horizontal)
                
                // Time Picker
                DatePicker("Order Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .padding(.horizontal)
                
                // The NavigationLink now passes all required arguments
                NavigationLink(destination: CheckoutScreen(
                    cake: cake,
                    customizationText: customizationText,
                    quantity: quantity,
                    flavor: selectedFlavor,
                    orderDate: selectedDate,
                    orderTime: selectedTime
                )) {
                    Text("Go to Checkout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Customize")
        .navigationBarTitleDisplayMode(.inline)
    }
}
