//
//  Customization_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct CustomizationScreen: View {
    var cake: Cake
    
    @State private var customizationText = ""
    @State private var quantity = 1
    
    var body: some View {
        VStack(spacing: 20) {
            Text(cake.name)
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            AsyncImage(url: URL(string: cake.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 200)
            .cornerRadius(10)
            
            Text("Customize Your Cake")
                .font(.headline)
            
            TextField("Custom message or instructions", text: $customizationText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...20)
                .padding(.horizontal)
            
            NavigationLink(destination: Checkout_Screen(
                cake: cake,
                customizationText: customizationText,
                quantity: quantity
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
        .navigationTitle("Customize")
    }
}
