//
//  CakeDetailScreen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI
// Parent view that creates and injects dependencies
struct CakeDetailView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var cake: Cake
    
    @State private var quantity: Int = 1
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var selectedFlavor = "Vanilla"
    @State private var customization = ""
    
    private let flavors = ["Vanilla", "Chocolate", "Strawberry", "Red Velvet"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: cake.imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .cornerRadius(20)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(cake.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(cake.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    Text("$\(cake.price, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select a Flavor")
                        .font(.headline)
                    Picker("Flavor", selection: $selectedFlavor) {
                        ForEach(flavors, id: \.self) { flavor in
                            Text(flavor).tag(flavor)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                HStack {
                    Text("Quantity")
                    Spacer()
                    Stepper("", value: $quantity, in: 1...100)
                    Text("\(quantity)")
                        .frame(width: 30)
                }
                .font(.headline)
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Order Date")
                        Spacer()
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    HStack {
                        Text("Order Time")
                        Spacer()
                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                .font(.headline)
                
                VStack(alignment: .leading) {
                    Text("Customization Notes")
                        .font(.headline)
                    TextEditor(text: $customization)
                        .frame(height: 100)
                        .border(Color.gray.opacity(0.5))
                }
                
                Divider()
                
                NavigationLink(destination: CheckoutScreen(
                    cake: cake,
                    customizationText: customization,
                    quantity: quantity,
                    flavor: selectedFlavor,
                    orderDate: selectedDate,
                    orderTime: selectedTime
                )
                .environmentObject(CheckoutViewModel(orderViewModel: OrderViewModel(), authViewModel: authViewModel))
                ) {
                    Text("Order Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(cake.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
