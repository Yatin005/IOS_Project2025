//
//  Customization_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

private enum AppTheme {
    static let accent = Color.pink
    static let gradient = LinearGradient(
        colors: [.pink.opacity(0.9), .purple.opacity(0.9), .blue.opacity(0.9)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

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
        NavigationStack {
            ZStack {
                // THEME: gradient backdrop
                AppTheme.gradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Title
                        VStack(spacing: 6) {
                            Text(cake.name)
                                .font(.largeTitle).bold()
                                .multilineTextAlignment(.center)
                            Text("Customize your cake")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        
                        // Image card
                        VStack(spacing: 0) {
                            AsyncImage(url: URL(string: cake.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ZStack {
                                        Rectangle().fill(.thinMaterial)
                                        ProgressView()
                                    }
                                case .success(let img):
                                    img
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    ZStack {
                                        Rectangle().fill(.thinMaterial)
                                        Image(systemName: "photo")
                                            .font(.title)
                                            .foregroundStyle(.secondary)
                                    }
                                @unknown default:
                                    Color.clear
                                }
                            }
                            .frame(height: 220)
                            .clipped()
                        }
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.12)))
                        .padding(.horizontal)
                        
                        // Options card
                        VStack(spacing: 14) {
                            // Flavor
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Flavor").font(.subheadline.weight(.semibold))
                                Picker("Flavor", selection: $selectedFlavor) {
                                    ForEach(flavors, id: \.self) { Text($0).tag($0) }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.accent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Custom message
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Message / Instructions").font(.subheadline.weight(.semibold))
                                TextField("e.g. “Happy Birthday, Aarya!”", text: $customizationText, axis: .vertical)
                                    .textInputAutocapitalization(.sentences)
                                    .lineLimit(3, reservesSpace: true)
                                    .padding(12)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Quantity
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Quantity").font(.subheadline.weight(.semibold))
                                HStack {
                                    Stepper("Qty: \(quantity)", value: $quantity, in: 1...20)
                                        .tint(AppTheme.accent)
                                }
                                .padding(12)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Date & time
                            VStack(spacing: 10) {
                                HStack {
                                    Text("Order Date").font(.subheadline.weight(.semibold))
                                    Spacer()
                                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                        .labelsHidden()
                                        .tint(AppTheme.accent)
                                }
                                .padding(12)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                
                                HStack {
                                    Text("Order Time").font(.subheadline.weight(.semibold))
                                    Spacer()
                                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .tint(AppTheme.accent)
                                }
                                .padding(12)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.12)))
                        .padding(.horizontal)
                        
                        // Checkout button
                        NavigationLink {
                            CheckoutScreen(
                                cake: cake,
                                customizationText: customizationText,
                                quantity: quantity,
                                flavor: selectedFlavor,
                                orderDate: selectedDate,
                                orderTime: selectedTime
                            )
                        } label: {
                            Text("Go to Checkout")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent) // THEME: accent
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Customize")
            .navigationBarTitleDisplayMode(.inline)
            // THEME: make nav bar match
            .toolbarBackground(AppTheme.gradient, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}
